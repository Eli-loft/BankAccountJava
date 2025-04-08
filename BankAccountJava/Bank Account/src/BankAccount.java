public class BankAccount {
    private double balance = 0;


    public void deposit(double amount){
        if (amount > 0){
            balance += amount;
        }
        else{
            System.out.println("Error: insufficient deposit amount");
        }
    }
    public void withdraw(double amount){
        double newBalance = balance - amount;
        
        /* Overdraft */
        if(newBalance >= 0){
            balance -= amount;
        }    
        else{
            System.out.println("Error: cant withdraw more than balance");
        }
    }
    
    public double getBalance(){
        return balance;
    }
    
}
