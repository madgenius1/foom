import React, { useState } from "react";
import { View, ScrollView, StyleSheet } from "react-native";
import {
  Card,
  Title,
  Paragraph,
  TextInput,
  Button,
  List,
  RadioButton,
  Text,
  Snackbar,
  Chip,
} from "react-native-paper";
import Icon from "react-native-vector-icons/MaterialCommunityIcons";
import { useAuth } from "../auth/AuthContext";
import { getMMFOptions, isValidPhoneNumber } from "../utils/helpers";
import { CONSTANTS } from "../utils/constants";

const ProfileSetupScreen: React.FC = () => {
  const { updateUserProfile } = useAuth();

  const [formData, setFormData] = useState({
    phoneNumber: "",
    age: "",
    savingsGoal: "",
    selectedMMF: "",
    screenTimeGoal: "8", // Default 8 hours
  });

  const [loading, setLoading] = useState(false);
  const [currentStep, setCurrentStep] = useState(1);
  const [error, setError] = useState("");
  const [snackbarVisible, setSnackbarVisible] = useState(false);

  const mmfOptions = getMMFOptions();
  const totalSteps = 4;

  const handleNext = () => {
    if (validateCurrentStep()) {
      if (currentStep < totalSteps) {
        setCurrentStep(currentStep + 1);
      } else {
        handleComplete();
      }
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    }
  };

  const validateCurrentStep = (): boolean => {
    switch (currentStep) {
      case 1: // Phone number
        if (!formData.phoneNumber) {
          setError("Please enter your phone number");
          setSnackbarVisible(true);
          return false;
        }
        if (!isValidPhoneNumber(formData.phoneNumber)) {
          setError("Please enter a valid Kenyan phone number");
          setSnackbarVisible(true);
          return false;
        }
        return true;

      case 2: // Age and goals
        if (
          !formData.age ||
          parseInt(formData.age) < 13 ||
          parseInt(formData.age) > 100
        ) {
          setError("Please enter a valid age (13-100)");
          setSnackbarVisible(true);
          return false;
        }
        if (!formData.savingsGoal || parseInt(formData.savingsGoal) < 1000) {
          setError("Please enter a savings goal of at least KES 1,000");
          setSnackbarVisible(true);
          return false;
        }
        return true;

      case 3: // MMF selection
        if (!formData.selectedMMF) {
          setError("Please select a Money Market Fund");
          setSnackbarVisible(true);
          return false;
        }
        return true;

      case 4: // Screen time goal
        const goal = parseInt(formData.screenTimeGoal);
        if (!goal || goal < 1 || goal > 16) {
          setError("Please set a realistic screen time goal (1-16 hours)");
          setSnackbarVisible(true);
          return false;
        }
        return true;

      default:
        return true;
    }
  };

  const handleComplete = async () => {
    setLoading(true);

    try {
      await updateUserProfile({
        phoneNumber: formData.phoneNumber,
        age: parseInt(formData.age),
        savingsGoal: parseInt(formData.savingsGoal),
        selectedMMF: formData.selectedMMF,
        profileComplete: true,
      });
    } catch (error: any) {
      console.error("Profile setup error:", error);
      setError("Failed to complete profile setup. Please try again.");
      setSnackbarVisible(true);
    } finally {
      setLoading(false);
    }
  };

  const renderStep = () => {
    switch (currentStep) {
      case 1:
        return (
          <View>
            <Icon
              name="phone"
              size={64}
              color="#6200EE"
              style={styles.stepIcon}
            />
            <Title style={styles.stepTitle}>Phone Number</Title>
            <Paragraph style={styles.stepDescription}>
              We'll use this for M-Pesa integration and account security
            </Paragraph>

            <TextInput
              label="Phone Number"
              value={formData.phoneNumber}
              onChangeText={(text) =>
                setFormData({ ...formData, phoneNumber: text })
              }
              mode="outlined"
              keyboardType="phone-pad"
              placeholder="+254 700 000 000"
              left={<TextInput.Icon icon="phone" />}
              style={styles.input}
            />

            <Paragraph style={styles.helperText}>
              Enter your Kenyan phone number (Safaricom, Airtel, or Telkom)
            </Paragraph>
          </View>
        );

      case 2:
        return (
          <View>
            <Icon
              name="target"
              size={64}
              color="#FF9800"
              style={styles.stepIcon}
            />
            <Title style={styles.stepTitle}>Goals & Profile</Title>
            <Paragraph style={styles.stepDescription}>
              Tell us about yourself and your savings goals
            </Paragraph>

            <TextInput
              label="Age"
              value={formData.age}
              onChangeText={(text) => setFormData({ ...formData, age: text })}
              mode="outlined"
              keyboardType="numeric"
              left={<TextInput.Icon icon="cake" />}
              style={styles.input}
            />

            <TextInput
              label="Savings Goal (KES)"
              value={formData.savingsGoal}
              onChangeText={(text) =>
                setFormData({ ...formData, savingsGoal: text })
              }
              mode="outlined"
              keyboardType="numeric"
              placeholder="50000"
              left={<TextInput.Icon icon="currency-usd" />}
              style={styles.input}
            />

            <Paragraph style={styles.helperText}>
              Set a realistic savings goal to work towards
            </Paragraph>
          </View>
        );

      case 3:
        return (
          <View>
            <Icon
              name="trending-up"
              size={64}
              color="#4CAF50"
              style={styles.stepIcon}
            />
            <Title style={styles.stepTitle}>Choose Your MMF</Title>
            <Paragraph style={styles.stepDescription}>
              Select a Money Market Fund for your investments
            </Paragraph>

            <RadioButton.Group
              onValueChange={(value) =>
                setFormData({ ...formData, selectedMMF: value })
              }
              value={formData.selectedMMF}
            >
              {mmfOptions.map((mmf) => (
                <Card key={mmf.id} style={styles.mmfCard}>
                  <Card.Content>
                    <View style={styles.mmfHeader}>
                      <RadioButton value={mmf.id} />
                      <View style={styles.mmfInfo}>
                        <Text style={styles.mmfName}>{mmf.name}</Text>
                        <Text style={styles.mmfRate}>
                          {mmf.rate}% annual return
                        </Text>
                        <View style={styles.mmfDetails}>
                          <Chip size="small">{mmf.riskLevel} Risk</Chip>
                          <Text style={styles.mmfMin}>
                            Min: KES {mmf.minInvestment.toLocaleString()}
                          </Text>
                        </View>
                      </View>
                    </View>
                  </Card.Content>
                </Card>
              ))}
            </RadioButton.Group>
          </View>
        );

      case 4:
        return (
          <View>
            <Icon
              name="clock-outline"
              size={64}
              color="#9C27B0"
              style={styles.stepIcon}
            />
            <Title style={styles.stepTitle}>Screen Time Goal</Title>
            <Paragraph style={styles.stepDescription}>
              Set your daily screen time target to earn more tokens
            </Paragraph>

            <TextInput
              label="Daily Screen Time Goal (hours)"
              value={formData.screenTimeGoal}
              onChangeText={(text) =>
                setFormData({ ...formData, screenTimeGoal: text })
              }
              mode="outlined"
              keyboardType="numeric"
              left={<TextInput.Icon icon="clock-outline" />}
              style={styles.input}
            />

            <Card style={styles.infoCard}>
              <Card.Content>
                <Text style={styles.infoTitle}>How it works:</Text>
                <Text style={styles.infoText}>
                  • Stay under {formData.screenTimeGoal || 8} hours daily to
                  earn tokens
                </Text>
                <Text style={styles.infoText}>
                  • 1 hour saved = {CONSTANTS.TOKENS_PER_HOUR_SAVED} FOOM tokens
                </Text>
                <Text style={styles.infoText}>
                  • Use tokens to invest in your chosen MMF
                </Text>
              </Card.Content>
            </Card>
          </View>
        );

      default:
        return null;
    }
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Title style={styles.title}>Complete Your Profile</Title>
        <Text style={styles.progress}>
          Step {currentStep} of {totalSteps}
        </Text>
      </View>

      <Card style={styles.card}>
        <Card.Content>{renderStep()}</Card.Content>
      </Card>

      <View style={styles.buttonContainer}>
        {currentStep > 1 && (
          <Button
            mode="outlined"
            onPress={handleBack}
            style={styles.backButton}
            disabled={loading}
          >
            Back
          </Button>
        )}

        <Button
          mode="contained"
          onPress={handleNext}
          style={styles.nextButton}
          loading={loading}
          disabled={loading}
        >
          {currentStep === totalSteps ? "Complete Setup" : "Next"}
        </Button>
      </View>

      <Snackbar
        visible={snackbarVisible}
        onDismiss={() => setSnackbarVisible(false)}
        duration={4000}
        action={{
          label: "Dismiss",
          onPress: () => setSnackbarVisible(false),
        }}
      >
        {error}
      </Snackbar>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  header: {
    padding: 20,
    paddingTop: 40,
    alignItems: "center",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#333",
  },
  progress: {
    fontSize: 14,
    color: "#666",
    marginTop: 8,
  },
  card: {
    marginHorizontal: 16,
    marginBottom: 16,
    elevation: 4,
  },
  stepIcon: {
    alignSelf: "center",
    marginBottom: 16,
  },
  stepTitle: {
    textAlign: "center",
    marginBottom: 8,
    color: "#333",
  },
  stepDescription: {
    textAlign: "center",
    marginBottom: 24,
    color: "#666",
  },
  input: {
    marginBottom: 16,
  },
  helperText: {
    fontSize: 12,
    color: "#666",
    textAlign: "center",
    marginTop: 8,
  },
  mmfCard: {
    marginBottom: 12,
    elevation: 2,
  },
  mmfHeader: {
    flexDirection: "row",
    alignItems: "center",
  },
  mmfInfo: {
    flex: 1,
    marginLeft: 12,
  },
  mmfName: {
    fontSize: 16,
    fontWeight: "500",
    marginBottom: 4,
  },
  mmfRate: {
    fontSize: 14,
    color: "#4CAF50",
    marginBottom: 8,
  },
  mmfDetails: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  mmfMin: {
    fontSize: 12,
    color: "#666",
  },
  infoCard: {
    backgroundColor: "#E3F2FD",
    marginTop: 16,
  },
  infoTitle: {
    fontSize: 16,
    fontWeight: "500",
    marginBottom: 8,
    color: "#1976D2",
  },
  infoText: {
    fontSize: 14,
    color: "#1976D2",
    marginBottom: 4,
  },
  buttonContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    paddingHorizontal: 16,
    paddingBottom: 32,
  },
  backButton: {
    flex: 0.4,
  },
  nextButton: {
    flex: 0.5,
    marginLeft: 16,
  },
});

export default ProfileSetupScreen;
