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
    last_block[:index] + 1
  end

  def proof_of_work(last_proof)
    proof = 0
    while !valid_proof?(last_proof, proof)
      proof += 1
    end
    proof
  end

  # Returns the last Block in the chain
  def last_block
    chain.last
  end

  # Hashes a Block
  def hash(block)
    # We must make sure that the Dictionary is Ordered, or we'll have inconsistent hashes
    block_string = block.sort.to_h.to_json.encode
    Digest::MD5.hexdigest(block_string)
  end

  private

  # Validates the Proof: Does hash(last_proof, proof) contain 4 leading zeroes?
  def valid_proof?(last_proof, proof)
    guess = "#{last_proof}#{proof}".encode
    guess_hash = Digest::MD5.hexdigest(guess)
    guess_hash[0..3] == "0000"
  end
end

# Generate a globally unique address for this node
node_identifier = SecureRandom.uuid.gsub("-", "")

# Instantiate the Blockchain
blockchain = Blockchain.new

get '/mine' do
  # We run the proof of work algorithm to get the next proof...
  last_block = blockchain.last_block
  last_proof = last_block[:proof]
  proof = blockchain.proof_of_work(last_proof)

  # We must receive a reward for finding the proof.
  # The sender is "0" to signify that this node has mined a new coin.
  blockchain.new_transaction("0", node_identifier, 1)

  # Forge the new Block by adding it to the chain
  previous_hash = blockchain.hash(last_block)
  block = blockchain.new_block(proof, previous_hash)

  response = {
    message:       "New Block Forged",
    index:         block[:index],
    transactions:  block[:transactions],
    proof:         block[:proof],
    previous_hash: block[:previous_hash],
  }
  status 200
  response.to_json
end

post '/transactions/new' do
  values = JSON.parse(request.body.read)
  required = %w(sender recipient amount)
  required.each do |key|
    return status 404 unless values[key]
  end

  # Create a new Transaction
  index = blockchain.new_transaction(values['sender'], values['recipient'], values['amount'])
  response = { message: "Transaction will be added to Block #{index}" }
  status 201
  response.to_json
end

get '/chain' do
  response = {
    chain:  blockchain.chain,
    length: blockchain.chain.length
  }
  response.to_json
end
