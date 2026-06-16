import hashlib
import time
import ed25519

#### warm up runs to stabilize the timing results 
for i in range(3):
    message = b"this is a recoooooord"
    message_hash = hashlib.sha256(message).digest()
print("Warmup hash.")

privKey, pubKey = ed25519.create_keypair()
msg = b'Message for Ed25519 signing'
signature = privKey.sign(msg, encoding='hex')

try:
    for i in range(3):
        pubKey.verify(signature, msg, encoding='hex')
    print("Signature verification warmed up!")
except:
    print("Signature warmup failed...")


starthash = time.time()

for i in range(30):
    message = b"this is a recoooooord"
    message_hash = hashlib.sha256(message).digest()

endhash = time.time()

hash_time = endhash-starthash

hash_time_low = hash_time*0.95
hash_time_high = hash_time*1.05
print("One record hash lower margin (ms):")
print(hash_time_low*1000)
print("One record hash (ms):")
print(hash_time*1000)
print("One record hash higher margin (ms):")
print(hash_time_high*1000)


privKey, pubKey = ed25519.create_keypair()
print("Private key (32 bytes):", privKey.to_ascii(encoding='hex'))
print("Public key (32 bytes): ", pubKey.to_ascii(encoding='hex'))

msg = b'Message for Ed25519 signing'
signature = privKey.sign(msg, encoding='hex')
print("Signature (64 bytes):", signature)

try:
    eddsastartverify = time.time()
    pubKey.verify(signature, msg, encoding='hex')
    eddsaendverify = time.time()
    print("The signature is valid.")
    # print("One single record signatures verification time:")
    one_sign = (eddsaendverify-eddsastartverify)*2
    #print(sign_for_one_proof)
except:
    print("Invalid signature!")


sign_low = one_sign*0.95
print("One record signature time lower margin (ms):")
print(sign_low*1000)
print("One record signature time (ms):")
print(one_sign*1000)
sign_high = one_sign*1.05
print("One record signature time higher margin (ms):")
print(sign_high*1000)

# compute_month_time = (sign_for_one_proof+hashes_for_one_proof)*100000000
# print("Computed monthly auditing time (days):")
# print(compute_month_time/(3600*24))

print("Lower margin audit time for 100M records (days):")
lower_margin = (hash_time_low + sign_low)*100000000
print(lower_margin/(3600*24))
print("Audit time for 100M records (days):")
audit_time = (hash_time + one_sign)*100000000
print(audit_time/(3600*24))
print("Higher margin audit time for 100M records (days):")
higher_margin = (hash_time_high + sign_high)*100000000
print(higher_margin/(3600*24))


