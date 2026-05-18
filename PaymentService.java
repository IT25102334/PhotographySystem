public class PaymentService {
    public class PaymentService {
        String file = "data/payments.txt";

        public void addPayment(Payment p) {
            FileUtil.writeToFile(file, p.toString());
        }
    }
}
