class Basket
    attr_accessor :catalogue

    def initialize(catalogue = Catalogue::default_catalogue)
        @catalogue = catalogue
    end
end
