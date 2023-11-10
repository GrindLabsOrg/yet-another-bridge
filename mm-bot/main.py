import ethereum
import herodotus

if __name__ == '__main__':
    while True:
        # 1. Listen event on starknet
        print("[+] Listening event on starknet")
        # TODO
        dst_addr = '0x'
        amount = 1
        print("[+] Event received")
        
        # 2. Transfer eth on ethereum
        # (bridging is complete for the user)
        print("[+] Transfering eth on ethereum")
        # TODO check the tx receipt
        ethereum.transfer(dst_addr, amount)
        print("[+] Transfer complete")
        
        # 3. Call herodotus to prove
        # extra: validate w3.eth.get_storage_at(addr, pos) before calling herodotus
        block = ethereum.get_latest_block()
        print("[+] Proving block {}".format(block))
        task_id = herodotus.herodotus_prove(block, order_id)
        print("[+] Block being proved with task id: {}".format(task_id))
        
        # 4. Poll herodotus to check task status
        print("[+] Polling herodotus for task status")
        completed = herodotus.herodotus_poll_status(task_id)
        print("[+] Task completed")
        
        # 5. Withdraw eth from starknet
        # (bridging is complete for the mm)
        if completed:
            print("[+] Withdraw eth from starknet")
            # TODO
