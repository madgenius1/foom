import React, { useState, useRef } from 'react';
import {
    View,
    StyleSheet,
    Dimensions,
    FlatList,
    ListRenderItem,
} from 'react-native';
import {
    Card,
    Title,
    Paragraph,
    Button,
    Text,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useNavigation } from '@react-navigation/native';
import { useAuthStore } from '../store/authStore';

const { width } = Dimensions.get('window');

interface OnboardingSlide {
    id: string;
    icon: string;
    title: string;
    description: string;
    color: string;
}

const slides: OnboardingSlide[] = [
    {
        id: '1',
        icon: 'cellphone-cog',
        title: 'Track Your Screen Time',
        description: 'Monitor your daily app usage and get insights into your digital habits.',
        color: '#6200EE',
    },
    {
        id: '2',
        icon: 'coin',
        title: 'Earn FOOM Tokens',
        description: 'Reduce your screen time and earn tokens that you can invest in real money market funds.',
        color: '#FFD700',
    },
    {
        id: '3',
        icon: 'trending-up',
        title: 'Invest & Grow',
        description: 'Use your earned tokens to invest in Kenyan money market funds and watch your savings grow.',
        color: '#4CAF50',
    },
    {
        id: '4',
        icon: 'shield-check',
        title: 'Build Better Habits',
        description: 'Set app limits, block distracting apps, and develop healthier digital habits.',
        color: '#FF9800',
    },
];

const OnboardingScreen: React.FC = () => {
    const navigation = useNavigation();
    const { setOnboardingComplete } = useAuthStore();
    const [currentSlide, setCurrentSlide] = useState(0);
    const flatListRef = useRef<FlatList>(null);

    const renderSlide: ListRenderItem<OnboardingSlide> = ({ item }) => (
        <View style={[styles.slide, { width }]}>
            <Card style={styles.card}>
                <Card.Content style={styles.cardContent}>
                    <View style={[styles.iconContainer, { backgroundColor: `${item.color}20` }]}>
                        <Icon name={item.icon} size={80} color={item.color} />
                    </View>
                    <Title style={[styles.title, { color: item.color }]}>
                        {item.title}
                    </Title>
                    <Paragraph style={styles.description}>
                        {item.description}
                    </Paragraph>
                </Card.Content>
            </Card>
        </View>
    );

    const goToNextSlide = () => {
        if (currentSlide < slides.length - 1) {
            const nextSlide = currentSlide + 1;
            flatListRef.current?.scrollToIndex({ index: nextSlide });
            setCurrentSlide(nextSlide);
        }
    };

    const goToPreviousSlide = () => {
        if (currentSlide > 0) {
            const prevSlide = currentSlide - 1;
            flatListRef.current?.scrollToIndex({ index: prevSlide });
            setCurrentSlide(prevSlide);
        }
    };

    const finishOnboarding = () => {
        setOnboardingComplete();
        navigation.navigate('Login' as never);
    };

    const skipOnboarding = () => {
        setOnboardingComplete();
        navigation.navigate('Login' as never);
    };

    return (
        <View style={styles.container}>
            <View style={styles.header}>
                <Button mode="text" onPress={skipOnboarding}>
                    Skip
                </Button>
            </View>

            <FlatList
                ref={flatListRef}
                data={slides}
                renderItem={renderSlide}
                horizontal
                pagingEnabled
                showsHorizontalScrollIndicator={false}
                onMomentumScrollEnd={(event) => {
                    const slideIndex = Math.round(event.nativeEvent.contentOffset.x / width);
                    setCurrentSlide(slideIndex);
                }}
            />

            <View style={styles.footer}>
                <View style={styles.pagination}>
                    {slides.map((_, index) => (
                        <View
                            key={index}
                            style={[
                                styles.paginationDot,
                                {
                                    backgroundColor: index === currentSlide ? '#6200EE' : '#E0E0E0',
                                    width: index === currentSlide ? 24 : 8,
                                },
                            ]}
                        />
                    ))}
                </View>

                <View style={styles.buttonContainer}>
                    {currentSlide > 0 && (
                        <Button
                            mode="outlined"
                            onPress={goToPreviousSlide}
                            style={styles.backButton}
                        >
                            Back
                        </Button>
                    )}

                    {currentSlide < slides.length - 1 ? (
                        <Button
                            mode="contained"
                            onPress={goToNextSlide}
                            style={styles.nextButton}
                        >
                            Next
                        </Button>
                    ) : (
                        <Button
                            mode="contained"
                            onPress={finishOnboarding}
                            style={styles.nextButton}
                        >
                            Get Started
                        </Button>
                    )}
                </View>
            </View>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        paddingHorizontal: 20,
        paddingTop: 40,
        paddingBottom: 20,
    },
    slide: {
        flex: 1,
        justifyContent: 'center',
        paddingHorizontal: 20,
    },
    card: {
        elevation: 8,
        borderRadius: 16,
        marginVertical: 20,
    },
    cardContent: {
        alignItems: 'center',
        paddingVertical: 40,
        paddingHorizontal: 20,
    },
    iconContainer: {
        width: 140,
        height: 140,
        borderRadius: 70,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 24,
    },
    title: {
        fontSize: 24,
        fontWeight: 'bold',
        textAlign: 'center',
        marginBottom: 16,
    },
    description: {
        fontSize: 16,
        textAlign: 'center',
        color: '#666',
        lineHeight: 24,
    },
    footer: {
        paddingHorizontal: 20,
        paddingBottom: 40,
    },
    pagination: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 32,
    },
    paginationDot: {
        height: 8,
        borderRadius: 4,
        marginHorizontal: 4,
    },
    buttonContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    backButton: {
        flex: 0.4,
    },
    nextButton: {
        flex: 0.5,
        marginLeft: 16,
    },
});

export default OnboardingScreen;