import firestore from "@react-native-firebase/firestore";
import auth from "@react-native-firebase/auth";
import { UserProfile } from "../auth/AuthContext";
import { DailyScreenTime } from "../store/screenTimeStore";
import { TokenTransaction, Investment } from "../store/walletStore";

// Firestore collections
const COLLECTIONS = {
  USERS: "users",
  SCREEN_TIME: "screenTime",
  TRANSACTIONS: "transactions",
  INVESTMENTS: "investments",
} as const;

// User Profile Operations
export const createUserProfile = async (
  userData: Partial<UserProfile>
): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const userRef = firestore().collection(COLLECTIONS.USERS).doc(user.uid);

  const profileData: UserProfile = {
    uid: user.uid,
    email: user.email!,
    displayName: user.displayName || "",
    profileComplete: false,
    createdAt: new Date(),
    ...userData,
  };

  await userRef.set(profileData, { merge: true });
};

export const updateUserProfile = async (
  updates: Partial<UserProfile>
): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const userRef = firestore().collection(COLLECTIONS.USERS).doc(user.uid);
  await userRef.update({
    ...updates,
    updatedAt: new Date(),
  });
};

export const getUserProfile = async (
  uid: string
): Promise<UserProfile | null> => {
  const userDoc = await firestore()
    .collection(COLLECTIONS.USERS)
    .doc(uid)
    .get();

  if (userDoc.exists()) {
    return userDoc.data() as UserProfile;
  }

  return null;
};

// Screen Time Operations
export const saveDailyScreenTime = async (
  date: string,
  screenTimeData: DailyScreenTime
): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const screenTimeRef = firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.SCREEN_TIME)
    .doc(date);

  await screenTimeRef.set(
    {
      ...screenTimeData,
      updatedAt: new Date(),
    },
    { merge: true }
  );
};

export const getDailyScreenTime = async (
  date: string
): Promise<DailyScreenTime | null> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const screenTimeDoc = await firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.SCREEN_TIME)
    .doc(date)
    .get();

  if (screenTimeDoc.exists()) {
    return screenTimeDoc.data() as DailyScreenTime;
  }

  return null;
};

export const getWeeklyScreenTime = async (): Promise<DailyScreenTime[]> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const weekAgo = new Date();
  weekAgo.setDate(weekAgo.getDate() - 7);

  const snapshot = await firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.SCREEN_TIME)
    .where("date", ">=", weekAgo.toISOString().split("T")[0])
    .orderBy("date", "desc")
    .get();

  return snapshot.docs.map((doc) => doc.data() as DailyScreenTime);
};

// Transaction Operations
export const saveTransaction = async (
  transaction: TokenTransaction
): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const transactionRef = firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.TRANSACTIONS)
    .doc(transaction.id);

  await transactionRef.set({
    ...transaction,
    createdAt: new Date(),
  });
};

export const getTransactions = async (
  limit: number = 50
): Promise<TokenTransaction[]> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const snapshot = await firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.TRANSACTIONS)
    .orderBy("timestamp", "desc")
    .limit(limit)
    .get();

  return snapshot.docs.map((doc) => doc.data() as TokenTransaction);
};

// Investment Operations
export const saveInvestment = async (investment: Investment): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const investmentRef = firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.INVESTMENTS)
    .doc(investment.id);

  await investmentRef.set({
    ...investment,
    createdAt: new Date(),
  });
};

export const getInvestments = async (): Promise<Investment[]> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const snapshot = await firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.INVESTMENTS)
    .orderBy("investedAt", "desc")
    .get();

  return snapshot.docs.map((doc) => doc.data() as Investment);
};

export const updateInvestment = async (
  investmentId: string,
  updates: Partial<Investment>
): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const investmentRef = firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.INVESTMENTS)
    .doc(investmentId);

  await investmentRef.update({
    ...updates,
    updatedAt: new Date(),
  });
};

export const deleteInvestment = async (investmentId: string): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const investmentRef = firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.INVESTMENTS)
    .doc(investmentId);

  await investmentRef.delete();
};

// Batch Operations for Performance
export const syncUserData = async (userData: {
  profile?: Partial<UserProfile>;
  screenTime?: { date: string; data: DailyScreenTime };
  transactions?: TokenTransaction[];
  investments?: Investment[];
}): Promise<void> => {
  const user = auth().currentUser;
  if (!user) throw new Error("User not authenticated");

  const batch = firestore().batch();

  // Update profile if provided
  if (userData.profile) {
    const userRef = firestore().collection(COLLECTIONS.USERS).doc(user.uid);
    batch.update(userRef, {
      ...userData.profile,
      updatedAt: new Date(),
    });
  }

  // Update screen time if provided
  if (userData.screenTime) {
    const screenTimeRef = firestore()
      .collection(COLLECTIONS.USERS)
      .doc(user.uid)
      .collection(COLLECTIONS.SCREEN_TIME)
      .doc(userData.screenTime.date);

    batch.set(
      screenTimeRef,
      {
        ...userData.screenTime.data,
        updatedAt: new Date(),
      },
      { merge: true }
    );
  }

  // Add transactions if provided
  if (userData.transactions) {
    userData.transactions.forEach((transaction) => {
      const transactionRef = firestore()
        .collection(COLLECTIONS.USERS)
        .doc(user.uid)
        .collection(COLLECTIONS.TRANSACTIONS)
        .doc(transaction.id);

      batch.set(transactionRef, {
        ...transaction,
        createdAt: new Date(),
      });
    });
  }

  // Add investments if provided
  if (userData.investments) {
    userData.investments.forEach((investment) => {
      const investmentRef = firestore()
        .collection(COLLECTIONS.USERS)
        .doc(user.uid)
        .collection(COLLECTIONS.INVESTMENTS)
        .doc(investment.id);

      batch.set(investmentRef, {
        ...investment,
        createdAt: new Date(),
      });
    });
  }

  await batch.commit();
};

// Real-time listeners
export const subscribeToUserProfile = (
  uid: string,
  callback: (profile: UserProfile | null) => void
) => {
  return firestore()
    .collection(COLLECTIONS.USERS)
    .doc(uid)
    .onSnapshot(
      (doc) => {
        if (doc.exists()) {
          callback(doc.data() as UserProfile);
        } else {
          callback(null);
        }
      },
      (error) => {
        console.error("Profile subscription error:", error);
        callback(null);
      }
    );
};

export const subscribeToTransactions = (
  callback: (transactions: TokenTransaction[]) => void,
  limit: number = 50
) => {
  const user = auth().currentUser;
  if (!user) {
    callback([]);
    return () => {};
  }

  return firestore()
    .collection(COLLECTIONS.USERS)
    .doc(user.uid)
    .collection(COLLECTIONS.TRANSACTIONS)
    .orderBy("timestamp", "desc")
    .limit(limit)
    .onSnapshot(
      (snapshot) => {
        const transactions = snapshot.docs.map(
          (doc) => doc.data() as TokenTransaction
        );
        callback(transactions);
      },
      (error) => {
        console.error("Transactions subscription error:", error);
        callback([]);
      }
    );
};
