module BitPulse::BitPulseVault {
    use sui::coin::{Coin, value, split, join};
    use sui::sui::SUI;
    use sui::tx_context::{TxContext};
    use sui::object::{UID};
    use sui::transfer;

    /// Vault object (on-chain)
    struct Vault has key {
        id: UID,
        owner: address,
        balance: u64,
    }

    /// Create vault
    public entry fun create_vault(ctx: &mut TxContext): Vault {
        Vault {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            balance: 0,
        }
    }

    /// Deposit real SUI coins
    public entry fun deposit(vault: &mut Vault, coin: Coin<SUI>) {
        let amount = value(&coin);
        vault.balance = vault.balance + amount;
        // coin is consumed (added to vault)
    }

    /// Withdraw SUI coins
    public entry fun withdraw(
        vault: &mut Vault,
        amount: u64,
        ctx: &mut TxContext
    ): Coin<SUI> {
        assert!(vault.owner == tx_context::sender(ctx), 1);
        assert!(vault.balance >= amount, 2);

        vault.balance = vault.balance - amount;

        let coin = coin::mint<SUI>(amount, ctx);
        coin
    }
}
