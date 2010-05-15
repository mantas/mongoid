# encoding: utf-8
module Mongoid #:nodoc:
  module Validations #:nodoc:
    # Validates whether or not a field is unique against the documents in the
    # database.
    #
    # Example:
    #
    #   class Person
    #     include Mongoid::Document
    #     field :title
    #
    #     validates_uniqueness_of :title
    #   end
    #  
    #  :in option allows to set external collection to check in
    #  :field option allows to set custom attribute name
    #
    class UniquenessValidator < ActiveModel::EachValidator
      def validate_each(document, attribute, value)
        if options.has_key? :field
          conditions = {options[:field] => value}
        else
          conditions = {attribute => value}
        end
        
        conditions[options[:scope]] = document.attributes[options[:scope]] if options.has_key?(:scope) && !options[:scope].blank?
        
        if options.has_key? :in
          scope = options[:in].classify.constantize
        else
          scope = document.class
        end
        
        return if scope.where(conditions).empty?
        
        if (document.new_record? || key_changed?(document)) || options.has_key?(:in)
          document.errors.add(attribute, :taken, :default => options[:message], :value => value)
        end
      end

      protected
      def key_changed?(document)
        (document.primary_key || {}).each do |key|
          return true if document.send("#{key}_changed?")
        end; false
      end
    end
  end
end
