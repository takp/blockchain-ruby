require 'json'
require 'digest/md5'

class Blockchain
  def initialize
    self.chain = []
    self.current_transactions = []
    self.new_block(1, 100)
  end
  
  # Creates a new Block and adds it to the chain
  def new_block(proof, previous_hash = nil)
    block = {
      index:         chain.length + 1,
      timestamp:     Time.now,
      transactions:  current_transactions,
      proof:         proof,
      previous_hash: previous_hash || Blockchain.hash(chain.last)
    }
    
    # Reset the current list of transactions
    self.current_transactions = []
    
    chain << block
    block
  end
  
  # Adds a new transaction to the list of transactions
  def new_transaction(sender, recipient, amount)
    current_transactions << {
      sender:    sender,
      recipient: recipient,
      amount:    amount
    }
    chain.length
  end

  private

  # Returns the last Block in the chain
  def last_block
    chain.last
  end

  # Hashes a Block
  def self.hash(block)
    # We must make sure that the Dictionary is Ordered, or we'll have inconsistent hashes
    block_string = block.sort.to_h.to_json
    Digest::MD5.hexdigest(block_string)
  end
end
