# frozen_string_literal: true

require "active_support/concern"
require_relative "concern/version"

module HasNamespace
  module Concern
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :namespaced_table
      end

      def self.table_name
        (self.namespaced_table || self.name).delete("::").underscore.pluralize
      end

      def self.table_name_prefix(ns)
        "#{ns.delete("::").underscore}_"
      end
  
      def self.module_prefix
        self.name.deconstantize
      end

      def self.namespace_association(association_type, association_name, scope, opts)
        assoc_class = association_name.to_s.classify
        ns = opts[:namespace] ? opts[:namespace] : self.module_prefix

        assoc_opts = (opts[:class_name] ? {} : {class_name: "#{ns}::#{assoc_class}"}).merge(opts)
        assoc_opts[:foreign_key] ||= "#{ns.delete("::").underscore}_#{association_name}_id"
        assoc_opts.except!(:namespace)

        self.send(association_type, association_name, scope, **assoc_opts)
      end

      def self.has_one_or_has_many!(association_type, association_name, scope, opts)
        if !opts[:through]
          opts[:foreign_key] ||= "#{table_name.singularize}_id"
        end

        namespace_association(association_type, association_name, scope, opts)
      end

      def self.belongs_to!(*args, **kargs)
        association_name, scope = args
        namespace_association(:belongs_to, association_name, scope, kargs)
      end

      def self.has_one!(*args, **kargs)
        association_name, scope = args
        has_one_or_has_many! :has_one, association_name, scope, kargs
      end
  
      def self.has_many!(*args, **kargs)
        association_name, scope = args
        has_one_or_has_many! :has_many, association_name, scope, kargs
      end

      def self.has_and_belongs_to_many!(*args, **kargs)
        association_name, scope = args
        ns = kargs[:namespace] ? kargs[:namespace] : self.module_prefix

        kargs[:association_foreign_key] ||= "#{self.table_name_prefix(ns)}#{association_name.to_s.singularize}_id"
        kargs[:foreign_key] ||= "#{table_name.singularize}_id"

        if !kargs[:join_table]
          kargs[:join_table] = table_name_prefix(ns) + [table_name.split('_').last, association_name.to_s].sort.join('_')
        end

        namespace_association(:has_and_belongs_to_many, association_name, scope, kargs)
      end
    end
  end
end
