module NotationTranslation

    def notation_to_coordinates(notation)
        coordinates = []
        coordinates[1] = notation[0].ord - 97
        coordinates[0] = notation[1].to_i - 1

        coordinates
    end
    
end


