module BitPulse::BitPulseVaultTest {
    use BitPulse::BitPulseVault;

    #[test]
    fun test_create_deposit_withdraw() {
        let mut registry = VaultRegistry { vaults: vector::empty(), next_id: 0 };
        let owner = 0x1;

        // create vault
        let vault_id = BitPulseVault::create_vault(&mut registry, &owner);

        // deposit
        BitPulseVault::deposit(&mut registry, vault_id, 500);
        let vault = &vector::borrow(&registry.vaults, 0);
        assert!(vault.balance == 500, 1);

        // withdraw
        BitPulseVault::withdraw(&mut registry, vault_id, 200);
        let vault2 = &vector::borrow(&registry.vaults, 0);
        assert!(vault2.balance == 300, 2);

        // yield calculation
        let y = BitPulseVault::calculate_yield(vault2);
        assert!(y == 3, 3); // 1% of 300
    }
}
