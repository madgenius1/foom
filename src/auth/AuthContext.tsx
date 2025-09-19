import React, { createContext, useContext, useEffect, useState } from 'react';
import auth, { FirebaseAuthTypes } from '@react-native-firebase/auth';
import firestore from '@react-native-firebase/firestore';
import { useAuthStore } from '../store/authStore';

export interface UserProfile {
    uid: string;
    email: string;
    displayName?: string;
    phoneNumber?: string;
    age?: number;
    savingsGoal?: number;
    selectedMMF?: string;
    profileComplete: boolean;
    createdAt: Date;
}

interface AuthContextType {
    user: FirebaseAuthTypes.User | null;
    userProfile: UserProfile | null;
    loading: boolean;
    signIn: (email: string, password: string) => Promise<void>;
    signUp: (email: string, password: string, displayName?: string) => Promise<void>;
    signOut: () => Promise<void>;
    updateUserProfile: (updates: Partial<UserProfile>) => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [user, setUser] = useState<FirebaseAuthTypes.User | null>(null);
    const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
    const [loading, setLoading] = useState(true);
    const { setAuthUser, clearAuthUser } = useAuthStore();

    useEffect(() => {
        const unsubscribe = auth().onAuthStateChanged(async (firebaseUser) => {
            setUser(firebaseUser);

            if (firebaseUser) {
                // Fetch user profile from Firestore
                try {
                    const userDoc = await firestore()
                        .collection('users')
                        .doc(firebaseUser.uid)
                        .get();

                    if (userDoc.exists()) {
                        const profileData = userDoc.data() as UserProfile;
                        setUserProfile(profileData);
                        setAuthUser(profileData);
                    } else {
                        // Create basic profile if doesn't exist
                        const newProfile: UserProfile = {
                            uid: firebaseUser.uid,
                            email: firebaseUser.email!,
                            displayName: firebaseUser.displayName || undefined,
                            profileComplete: false,
                            createdAt: new Date(),
                        };

                        await firestore()
                            .collection('users')
                            .doc(firebaseUser.uid)
                            .set(newProfile);

                        setUserProfile(newProfile);
                        setAuthUser(newProfile);
                    }
                } catch (error) {
                    console.error('Error fetching user profile:', error);
                }
            } else {
                setUserProfile(null);
                clearAuthUser();
            }

            setLoading(false);
        });

        return unsubscribe;
    }, [setAuthUser, clearAuthUser]);

    const signIn = async (email: string, password: string) => {
        try {
            await auth().signInWithEmailAndPassword(email, password);
        } catch (error) {
            console.error('Sign in error:', error);
            throw error;
        }
    };

    const signUp = async (email: string, password: string, displayName?: string) => {
        try {
            const credential = await auth().createUserWithEmailAndPassword(email, password);

            if (displayName && credential.user) {
                await credential.user.updateProfile({ displayName });
            }
        } catch (error) {
            console.error('Sign up error:', error);
            throw error;
        }
    };

    const signOut = async () => {
        try {
            await auth().signOut();
        } catch (error) {
            console.error('Sign out error:', error);
            throw error;
        }
    };

    const updateUserProfile = async (updates: Partial<UserProfile>) => {
        if (!user || !userProfile) return;

        try {
            const updatedProfile = { ...userProfile, ...updates };

            await firestore()
                .collection('users')
                .doc(user.uid)
                .update(updates);

            setUserProfile(updatedProfile);
            setAuthUser(updatedProfile);
        } catch (error) {
            console.error('Error updating user profile:', error);
            throw error;
        }
    };

    const value = {
        user,
        userProfile,
        loading,
        signIn,
        signUp,
        signOut,
        updateUserProfile,
    };

    return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (context === undefined) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
};