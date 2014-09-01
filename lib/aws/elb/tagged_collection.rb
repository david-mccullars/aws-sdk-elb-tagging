module AWS
  class ELB
    # This module provides methods for filtering the collection with
    # tags.
    #
    #     collecion.tagged('prod').each do {|obj| ... }
    #
    TaggedCollection = AWS::EC2::TaggedCollection
  end
end
