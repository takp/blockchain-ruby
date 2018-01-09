class Blockchain
  def initialize
    self.chain = []
    self.current_transactions = []
  end
  
  # Creates a new Block and adds it to the chain
  def new_block
  end
  
  # Adds a new transaction to the list of transactions
  def new_transaction
  end
  
  class << self
    # Hashes a Block
    def hash(block)
    end
    
    # Returns the last Block in the chain
    def last_block
    end
  end
end
