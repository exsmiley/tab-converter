Class TabColumn {
    # string_mapping is a hash that maps string name to fret number
    # fret number range (0 -> num_frets_of_instrument)
    def initialize(string_mapping)
        @string_mapping = string_mapping
    end
}


Class Tab {
    # columns can be either a single note or a chord
    def initialize(tab_columns)
        @columns = tab_columns
    end

    def self.construct_from_text()
        # TODO return a new Tab object from the text file
        return Tab([])
    end
}