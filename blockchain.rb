require 'json'
require 'digest/md5'
require 'sinatra'
require 'securerandom'

class Blockchain
  attr_accessor :chain, :current_transactions
  def initialize
    @chain = []
    @current_transactions = []
    # Create the genesis block
    new_block(1, 100)
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

  def proof_of_work(last_proof)
    proof = 0
    while !valid_prrof?
      proof += 1
    end
    proof
  end

  private

  # Returns the last Block in the chain
  def last_block
    chain.last
  end

  # Validates the Proof: Does hash(last_proof, proof) contain 4 leading zeroes?
  def valid_proof?(last_proof, proof)
    guess = "#{last_proof}#{proof}".encode
    guess_hash = Digest::MD5.hexdigest(guess)
    guess_hash[0..3] == "0000"
  end

  # Hashes a Block
  def self.hash(block)
    # We must make sure that the Dictionary is Ordered, or we'll have inconsistent hashes
    block_string = block.sort.to_h.to_json.encode
    Digest::MD5.hexdigest(block_string)
  end
end

# Generate a globally unique address for this node
node_identifier = SecureRandom.uuid.gsub("-", "")

# Instantiate the Blockchain
blockchain = Blockchain.new

get '/mine' do
  "We'll mine a new Block"
end

post '/transactions/new' do
  "We'll add a new transaction"
end

get '/chain' do
  response = {
    chain:  blockchain.chain,
    length: blockchain.chain.length
  }
  response.to_json
end
