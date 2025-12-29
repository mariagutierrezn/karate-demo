package examples.comments;

import com.intuit.karate.junit5.Karate;

public class CommentsRunner {

    @Karate.Test
    Karate commentsRunner() {
        return Karate.run("comments").relativeTo(getClass());
    }

}
