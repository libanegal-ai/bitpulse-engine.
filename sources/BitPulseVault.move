module BitPulse::BitPulseVault {
    use sui::coin::{Coin, balance};
    use sui::signer;

    struct Vault has key, store {
        owner: address,
        balance: u64,
        id: u64,
    }

    struct VaultRegistry has key, store {
        vaults: vector<Vault>,
        next_id: u64,
    }

    public fun create_vault(registry: &mut VaultRegistry, owner: &signer): u64 {
        let id = registry.next_id;
        let vault = Vault { owner: signer::address_of(owner), balance: 0, id };
        vector::push_back(&mut registry.vaults, vault);
        registry.next_id = id + 1;
        id
    }

    public fun deposit(registry: &mut VaultRegistry, vault_id: u64, amount: u64) {
        let vault_ref = borrow_vault_mut(registry, vault_id);
        vault_ref.balance = vault_ref.balance + amount;
    }

    public fun withdraw(registry: &mut VaultRegistry, vault_id: u64, amount: u64) {
        let vault_ref = borrow_vault_mut(registry, vault_id);
        assert!(vault_ref.balance >= amount, 1);
        vault_ref.balance = vault_ref.balance - amount;
    }

    public fun calculate_yield(vault: &Vault): u64 {
        vault.balance / 100
    }

    fun borrow_vault_mut(registry: &mut VaultRegistry, vault_id: u64): &mut Vault {
        let i = vector::length(&registry.vaults);
        let mut idx = 0;
        while (idx < i) {
            let v = &mut vector::borrow_mut(&mut registry.vaults, idx);
            if (v.id == vault_id) {
                return v;
            };
            idx = idx + 1;
        };
        abort 2;
    }
}
