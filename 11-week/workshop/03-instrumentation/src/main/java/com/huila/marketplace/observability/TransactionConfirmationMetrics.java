package com.huila.marketplace.observability;

import io.micrometer.core.instrument.MeterRegistry;
import java.time.Duration;
import java.util.Objects;

/**
 * Reference instrumentation for the modular-monolith MVP in the project ZIP.
 * This class is not wired into TransactionService because its private repository
 * is not available in this workshop fork.
 */
public final class TransactionConfirmationMetrics {

    private static final String COUNTER_NAME = "market_agri.transaction.confirmations";
    private static final String TIMER_NAME = "market_agri.transaction.confirmation.duration";

    private final MeterRegistry registry;

    public TransactionConfirmationMetrics(MeterRegistry registry) {
        this.registry = Objects.requireNonNull(registry, "registry");
    }

    public void record(Outcome outcome, Duration elapsed) {
        Objects.requireNonNull(outcome, "outcome");
        Objects.requireNonNull(elapsed, "elapsed");
        if (elapsed.isNegative()) {
            throw new IllegalArgumentException("elapsed must not be negative");
        }

        String label = outcome.label();
        registry.counter(COUNTER_NAME, "outcome", label).increment();
        registry.timer(TIMER_NAME, "outcome", label).record(elapsed);
    }

    public enum Outcome {
        CONFIRMED("confirmed"),
        ALREADY_CONFIRMED("already_confirmed"),
        SESSION_NOT_FOUND("session_not_found");

        private final String label;

        Outcome(String label) {
            this.label = label;
        }

        private String label() {
            return label;
        }
    }
}
