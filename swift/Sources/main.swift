import Foundation
import XpringKit


func demoXRP() throws {
// A URL to reach the remote rippled node at.
let grpcAddress = "alpha.test.xrp.xpring.io:50051"

// A wallet that exists on Testnet.
let seed = "snYP7oArxKepd3GPDcrjMsJYiJeJB";
guard let wallet = Wallet(seed: seed) else {
  print("The given seed is not valid: \(seed)")
  exit(0)
}

// A recipient address.
let recipientAddress = "X7cBcY4bdTTzk3LHmrKAK6GyrirkXfLHGFxzke5zTmYMfw4"
let dropsToSend: UInt64 = 10

print("\nUsing rippled node located at: \(grpcAddress)\n")
let xrpClient = XpringClient(grpcURL: grpcAddress, useNewProtocolBuffers: true)

print("Retrieving balance for \(wallet.address) ..")
let balance = try xrpClient.getBalance(for: wallet.address)

print("Balance was \(balance) drops!\n")

print("Sending:")
print("- Drops \(dropsToSend)")
print("- To: \(recipientAddress)")
print("- From: \(wallet.address)\n")
let hash = try xrpClient.send(dropsToSend, to: recipientAddress, from: wallet)

print("Hash for transaction:\n\(hash)\n")

let status = try xrpClient.getTransactionStatus(for: hash)
print("Result for transaction is:\n\(status)\n");
}

func demoILP() throws {
  let grpcUrl = "hermes-grpc.ilpv4.dev"
  let demoUserId = "demo_user"
  let demoUserAuthToken = "2S1PZh3fEKnKg"

  print("\nUsing Hermes node located at: \(grpcUrl) \n")
  let ilpClient = IlpClient(grpcURL: grpcUrl)


  print("Retrieving balance for \(demoUserId)...")
  let getBalance = try! ilpClient.getBalance(for: demoUserId, withAuthorization: demoUserAuthToken)
  print("Net balance was \(getBalance.netBalance) with asset scale \(getBalance.assetScale)")

  let receiverPaymentPointer = "$money.ilpv4.dev/demo_receiver"
  let amountToSend: UInt64 = 100
  print("\nSending payment:")
  print("- From: \(demoUserId)")
  print("- To: \(receiverPaymentPointer)")
  print("- Amount: \(amountToSend) drops")
  let payment = try ilpClient.sendPayment(amountToSend,
                                          to: receiverPaymentPointer,
                                          from: demoUserId,
                                          withAuthorization: demoUserAuthToken)

  print("\nPayment sent!")
  print("Amount sent: \(payment.amountSent)")
  print("Amount delivered: \(payment.amountDelivered)")
  print("Payment was \((payment.successfulPayment ? "successful!" : "unsuccessful!"))")

  let balanceAfterPayment = try ilpClient.getBalance(for: demoUserId, withAuthorization: demoUserAuthToken);
  print("Net balance after sending payment was \(balanceAfterPayment.netBalance)")
}

print ("-------------------------------------------------------")
print ("Demoing XRP")
try demoXRP()
print ("-------------------------------------------------------")
print ("Demoing ILP")
sleep(10)
try demoILP()
