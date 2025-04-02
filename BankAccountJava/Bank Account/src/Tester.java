import java.util.Scanner;
public class Tester {
    public static void main(String[] args){
        /*initialize objects*/
        BankAccount testAccount = new BankAccount();
        try (Scanner input = new Scanner(System.in)) {
            
            
            Boolean stillIn = true;
            
            /* stays in till exit */
            while(stillIn){
                /*question*/
                System.out.println("What would you like to do: withdraw, deposit, or exit");
                String action  = input.nextLine();
                



                if (null == action){
                    System.out.println("Please enter a valid option: deposit, withdraw, or exit. ");
                    
                }
                /*withdraw*/
                else /*deposit */ switch (action) {
                    case "deposit" ->                         {
                            System.out.println("How much would you like to deposit?");
                            double amount = input.nextDouble();
                            input.nextLine();
                            testAccount.deposit(amount);
                            System.out.println("Your new balance: $" + testAccount.getBalance());
                        }
                    case "withdraw" ->                         {
                            System.out.println("How much would you like to withdraw?");
                            double amount = input.nextDouble();
                            input.nextLine();
                            testAccount.withdraw(amount);
                            System.out.println("Your new balance: $" + testAccount.getBalance());
                        }
                    case "exit" -> stillIn = false;
                    /*error handeling */
                    default -> System.out.println("Please enter a valid option: deposit, withdraw, or exit. ");
                }
                
                
            }
        }
        
    }
}
