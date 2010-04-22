# encoding: utf-8
module Mongoid #:nodoc:
  module Associations #:nodoc:
    # Represents an relational one-to-one association with an object in a
    # separate collection or database.
    class HasOneRelated < Proxy

      delegate :nil?, :to => :target

      # Builds a new Document and sets it as the association.
      #
      # Returns the newly created object.
      def build(attributes = {})
        @target = @klass.instantiate(attributes)
        
        if @foreign_type
          inverse = @target.associations.values.detect do |metadata|
            metadata.options.name == @options.as.to_s
          end
        else
          inverse = @target.associations.values.detect do |metadata|
            metadata.options.klass == @parent.class
          end
        end
        name = inverse.name
        @target.send("#{name}=", @parent)
        @target
      end

      # Builds a new Document and sets it as the association, then saves the
      # newly created document.
      #
      # Returns the newly created object.
      def create(attributes)
        build(attributes).tap(&:save)
      end

      # Initializing a related association only requires looking up the objects
      # by their ids.
      #
      # Options:
      #
      # document: The +Document+ that contains the relationship.
      # options: The association +Options+.
      def initialize(document, options, target = nil)
        @parent, @klass, @options = document, options.klass, options
        
        @foreign_key = options.foreign_key
        
        pre_conditions = { @foreign_key => @parent.id }
        
        if options.as
          @foreign_type = options.as.to_s+"_type"
          
          pre_conditions[@foreign_type] = document.class.to_s
        end
        
        @target = target || @klass.first(:conditions => pre_conditions)
        extends(options)
      end

      class << self
        # Preferred method for creating the new +RelatesToMany+ association.
        #
        # Options:
        #
        # document: The +Document+ that contains the relationship.
        # options: The association +Options+.
        def instantiate(document, options, target = nil)
          new(document, options, target)
        end

        # Returns the macro used to create the association.
        def macro
          :has_one_related
        end

        # Perform an update of the relationship of the parent and child. This
        # will assimilate the child +Document+ into the parent's object graph.
        #
        # Options:
        #
        # related: The related object to update.
        # document: The parent +Document+.
        # options: The association +Options+
        #
        # Example:
        #
        # <tt>HasOneToRelated.update(game, person, options)</tt>
        def update(target, document, options)
          if target
            name = document.class.to_s.underscore
            target.send("#{name}=", document)
            return instantiate(document, options, target)
          end
          target
        end
      end

    end
  end
end
