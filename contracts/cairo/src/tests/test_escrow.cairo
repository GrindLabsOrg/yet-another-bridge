mod Escrow {
    use starknet::{
        EthAddress, ContractAddress, ClassHash, SyscallResultTrait, contract_address_const
    };
    use starknet::syscalls::deploy_syscall;
    use starknet::testing::{set_contract_address, set_caller_address};

    use yab::contracts::ERC20::ERC20;
    use yab::interfaces::IERC20::{IERC20Dispatcher, IERC20DispatcherTrait};

    use yab::contracts::escrow::{Escrow, IEscrowDispatcher, IEscrowDispatcherTrait, Order};

    use yab::mocks::mock_EVMFactsRegistry::EVMFactsRegistry;
    use yab::interfaces::IEVMFactsRegistry::{
        IEVMFactsRegistryDispatcher, IEVMFactsRegistryDispatcherTrait
    };

    use integer::BoundedInt;

    use yab::tests::utils::constants::EscrowConstants::{
        USER, OWNER, MM_STARKNET, MM_ETHEREUM, ETH_TRANSFER_CONTRACT
    };

    fn setup() -> (IEscrowDispatcher, IERC20Dispatcher) {
        let eth_token = deploy_erc20('ETH', '$ETH', BoundedInt::max(), OWNER()); // 0x1
        let evm_facts_registry = deploy_mock_EVMFactsRegistry(); // 0x2
        let escrow = deploy_escrow(
            evm_facts_registry.contract_address,
            ETH_TRANSFER_CONTRACT(),
            MM_ETHEREUM(),
            MM_STARKNET(),
            eth_token.contract_address
        ); // 0x3

        set_contract_address(OWNER());
        eth_token.transfer(USER(), BoundedInt::max());

        set_contract_address(USER());
        eth_token.approve(escrow.contract_address, BoundedInt::max());

        (escrow, eth_token)
    }

    fn deploy_escrow(
        herodotus_facts_registry_contract: ContractAddress,
        eth_transfer_contract: EthAddress,
        mm_ethereum_contract: EthAddress,
        mm_starknet_contract: ContractAddress,
        native_token_eth_starknet: ContractAddress
    ) -> IEscrowDispatcher {
        let mut calldata: Array<felt252> = ArrayTrait::new();
        calldata.append(herodotus_facts_registry_contract.into());
        calldata.append(eth_transfer_contract.into());
        calldata.append(mm_ethereum_contract.into());
        calldata.append(mm_starknet_contract.into());
        calldata.append(native_token_eth_starknet.into());

        let (address, _) = deploy_syscall(
            Escrow::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), true
        )
            .unwrap_syscall();

        return IEscrowDispatcher { contract_address: address };
    }

    fn deploy_mock_EVMFactsRegistry() -> IEVMFactsRegistryDispatcher {
        let mut calldata: Array<felt252> = ArrayTrait::new();
        let (address, _) = deploy_syscall(
            EVMFactsRegistry::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), true
        )
            .unwrap_syscall();

        return IEVMFactsRegistryDispatcher { contract_address: address };
    }

    fn deploy_erc20(
        name: felt252, symbol: felt252, initial_supply: u256, recipent: ContractAddress
    ) -> IERC20Dispatcher {
        let mut calldata = array![name, symbol];
        Serde::serialize(@initial_supply, ref calldata);
        calldata.append(recipent.into());

        let (address, _) = deploy_syscall(
            ERC20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), true
        )
            .unwrap_syscall();

        return IERC20Dispatcher { contract_address: address };
    }

    #[test]
    #[available_gas(200000000)]
    fn test_happy_path() {
        let (escrow, eth_token) = setup();

        // check balance
        assert(eth_token.balanceOf(escrow.contract_address) == 0, 'init: wrong balance');
        assert(eth_token.balanceOf(MM_STARKNET()) == 0, 'init: wrong balance');

        set_contract_address(USER());
        let order = Order { recipient_address: 12345.try_into().unwrap(), amount: 500 };
        let order_id = escrow.set_order(order);

        // check balance
        assert(eth_token.balanceOf(escrow.contract_address) == 500, 'set_order: wrong balance ');
        assert(eth_token.balanceOf(MM_STARKNET()) == 0, 'set_order: wrong balance');

        // check Order
        assert(order_id == 0, 'wrong order_id');
        let order_save = escrow.get_order(order_id);
        assert(order.recipient_address == order_save.recipient_address, 'wrong recipient_address');
        assert(order.amount == order_save.amount, 'wrong amount');
        assert(!escrow.get_order_used(order_id), 'wrong order used');

        set_contract_address(MM_STARKNET());
        escrow.withdraw(order_id, 0, 0);

        // check Order
        assert(escrow.get_order_used(order_id), 'wrong order used');
        // check balance
        assert(eth_token.balanceOf(escrow.contract_address) == 0, 'withdraw: wrong balance');
        assert(eth_token.balanceOf(MM_STARKNET()) == 500, 'withdraw: wrong balance');
    }
}