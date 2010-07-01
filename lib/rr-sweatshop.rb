require 'randexp'

require 'active_support/core_ext/class/attribute_accessors'

require 'rr-sweatshop/sweatshop'
require 'rr-sweatshop/unique'

module RestfulResource
  # Adds a fixture to record map.
  # Block is supposed to return a hash of attributes.
  #
  # @param  name  [Symbol, String]  Name of the fixture
  # @param  blk   [Proc]            A proc that returns fixture attributes
  #
  # @returns nil
  #
  # @api    public
  def self.fixture(name = default_fauxture_name, &blk)
    Sweatshop.add(self, name, &blk)
  end

  # Creates an instance from hash of attributes, saves it
  # and adds it to the record map. Attributes given as the
  # second argument are merged into attributes from fixture.
  #
  # If record is valid because of duplicated property value,
  # this method does a retry.
  #
  # @param     name        [Symbol]
  # @param     attributes  [Hash]
  #
  # @api       public
  #
  # @returns   [RestfulResource]    added instance
  def self.generate(name = default_fauxture_name, attributes = {})
    name, attributes = default_fauxture_name, name if name.is_a? Hash
    Sweatshop.create(self, name, attributes)
  end

  # Returns a Hash of attributes from the model map.
  #
  # @param     name     [Symbol]   name of the fauxture to use
  #
  # @returns   [Hash]              existing instance of a model from the model map
  # @raises    NoFixtureExist      when requested fixture does not exist in the model map
  #
  # @api       public
  def self.generate_attributes(name = default_fauxture_name)
    Sweatshop.attributes(self, name)
  end

  # Returns a pre existing instance of a model from the record map
  #
  # @param     name     [Symbol]                        name of the fauxture to pick
  #
  # @returns   [RestfulResource]                   existing instance of a model from the record map
  # @raises     RestfulResource::Sweatshop::NoFixtureExist   when requested fixture does not exist in the record map
  #
  # @api       public
  def self.pick(name = default_fauxture_name)
    Sweatshop.pick(self, name)
  end

  # Default fauxture name. Usually :default.
  #
  # @returns   [Symbol]   default fauxture name
  # @api       public
  def self.default_fauxture_name
    :default
  end

   class << self
     alias_method :fix, :fixture
     alias_method :gen_attrs, :generate_attributes
     alias_method :gen, :generate  
   end
end