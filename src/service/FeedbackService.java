public class FeedbackService {

    String file = "data/feedback.txt";

    public void addFeedback(Feedback f) {
        FileUtil.writeToFile(file, f.toString());
    }
}
