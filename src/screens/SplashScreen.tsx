import React, { useEffect } from 'react';
import { View, StyleSheet, Animated } from 'react-native';
import { Text, ActivityIndicator } from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';

const SplashScreen: React.FC = () => {
    const fadeAnim = new Animated.Value(0);
    const scaleAnim = new Animated.Value(0.8);

    useEffect(() => {
        Animated.parallel([
            Animated.timing(fadeAnim, {
                toValue: 1,
                duration: 1000,
                useNativeDriver: true,
            }),
            Animated.spring(scaleAnim, {
                toValue: 1,
                tension: 50,
                friction: 7,
                useNativeDriver: true,
            }),
        ]).start();
    }, []);

    return (
        <View style={styles.container}>
            <Animated.View
                style={[
                    styles.content,
                    {
                        opacity: fadeAnim,
                        transform: [{ scale: scaleAnim }],
                    },
                ]}
            >
                <Icon name="cellphone-cog" size={100} color="#6200EE" />
                <Text style={styles.title}>FOOM</Text>
                <Text style={styles.subtitle}>Focus. Earn. Invest.</Text>

                <View style={styles.loadingContainer}>
                    <ActivityIndicator size="small" color="#6200EE" />
                </View>
            </Animated.View>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
        justifyContent: 'center',
        alignItems: 'center',
    },
    content: {
        alignItems: 'center',
    },
    title: {
        fontSize: 48,
        fontWeight: 'bold',
        color: '#6200EE',
        marginTop: 16,
        letterSpacing: 2,
    },
    subtitle: {
        fontSize: 18,
        color: '#666',
        marginTop: 8,
        fontStyle: 'italic',
    },
    loadingContainer: {
        marginTop: 32,
    },
});

export default SplashScreen;