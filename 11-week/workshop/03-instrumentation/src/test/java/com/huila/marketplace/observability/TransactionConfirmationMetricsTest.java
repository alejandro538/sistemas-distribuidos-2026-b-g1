package com.huila.marketplace.observability;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import java.time.Duration;
import org.junit.jupiter.api.Test;

class TransactionConfirmationMetricsTest {

    @Test
    void recordsConfirmationCountAndDurationWithBoundedOutcomeTag() {
        var registry = new SimpleMeterRegistry();
        var metrics = new TransactionConfirmationMetrics(registry);

        metrics.record(TransactionConfirmationMetrics.Outcome.CONFIRMED, Duration.ofMillis(125));

        assertEquals(1.0, registry.get("market_agri.transaction.confirmations")
                .tag("outcome", "confirmed").counter().count());
        assertEquals(1, registry.get("market_agri.transaction.confirmation.duration")
                .tag("outcome", "confirmed").timer().count());
        assertEquals(0.125, registry.get("market_agri.transaction.confirmation.duration")
                .tag("outcome", "confirmed").timer().totalTime(java.util.concurrent.TimeUnit.SECONDS), 0.0001);
    }

    @Test
    void rejectsNegativeElapsedDuration() {
        var metrics = new TransactionConfirmationMetrics(new SimpleMeterRegistry());

        assertThrows(IllegalArgumentException.class,
                () -> metrics.record(TransactionConfirmationMetrics.Outcome.CONFIRMED, Duration.ofMillis(-1)));
    }
}
