import React, { useState } from 'react';
import { StyleSheet, ViewStyle, View } from 'react-native';
import { 
  TextInput as PaperTextInput, 
  TextInputProps,
  Text,
  HelperText 
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';

interface CustomInputProps extends Omit<TextInputProps, 'theme'> {
  label: string;
  placeholder?: string;
  value: string;
  onChangeText: (text: string) => void;
  variant?: 'outlined' | 'flat';
  size?: 'small' | 'medium' | 'large';
  leftIcon?: string;
  rightIcon?: string;
  onRightIconPress?: () => void;
  helperText?: string;
  errorText?: string;
  required?: boolean;
  customStyle?: ViewStyle;
  testID?: string;
}

const Input: React.FC<CustomInputProps> = ({
  label,
  placeholder,
  value,
  onChangeText,
  variant = 'outlined',
  size = 'medium',
  leftIcon,
  rightIcon,
  onRightIconPress,
  helperText,
  errorText,
  required = false,
  disabled = false,
  secureTextEntry = false,
  keyboardType = 'default',
  autoCapitalize = 'sentences',
  multiline = false,
  numberOfLines = 1,
  maxLength,
  customStyle,
  testID,
  ...props
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const getSizeStyles = () => {
    switch (size) {
      case 'small':
        return {
          fontSize: 14,
          paddingVertical: 8,
        };
      case 'large':
        return {
          fontSize: 18,
          paddingVertical: 16,
        };
      case 'medium':
      default:
        return {
          fontSize: 16,
          paddingVertical: 12,
        };
    }
  };

  const getInputHeight = () => {
    if (multiline) {
      return numberOfLines * 24 + 32; // Approximate line height + padding
    }
    return size === 'small' ? 48 : size === 'large' ? 64 : 56;
  };

  const handleTogglePassword = () => {
    setShowPassword(!showPassword);
  };

  const renderLeftIcon = () => {
    if (!leftIcon) return undefined;
    
    return (
      <PaperTextInput.Icon 
        icon={leftIcon}
        size={20}
        iconColor={isFocused ? '#6200EE' : '#757575'}
      />
    );
  };

  const renderRightIcon = () => {
    // Handle password visibility toggle
    if (secureTextEntry) {
      return (
        <PaperTextInput.Icon
          icon={showPassword ? 'eye-off' : 'eye'}
          size={20}
          iconColor={isFocused ? '#6200EE' : '#757575'}
          onPress={handleTogglePassword}
        />
      );
    }
    
    // Handle custom right icon
    if (rightIcon) {
      return (
        <PaperTextInput.Icon
          icon={rightIcon}
          size={20}
          iconColor={isFocused ? '#6200EE' : '#757575'}
          onPress={onRightIconPress}
        />
      );
    }
    
    return undefined;
  };

  const inputStyle = {
    backgroundColor: disabled ? '#F5F5F5' : '#FFFFFF',
    height: getInputHeight(),
    ...getSizeStyles(),
    ...customStyle,
  };

  const displayLabel = required ? `${label} *` : label;

  return (
    <View style={styles.container}>
      <PaperTextInput
        label={displayLabel}
        placeholder={placeholder}
        value={value}
        onChangeText={onChangeText}
        mode={variant}
        secureTextEntry={secureTextEntry && !showPassword}
        keyboardType={keyboardType}
        autoCapitalize={autoCapitalize}
        multiline={multiline}
        numberOfLines={numberOfLines}
        maxLength={maxLength}
        disabled={disabled}
        error={!!errorText}
        left={renderLeftIcon()}
        right={renderRightIcon()}
        onFocus={() => setIsFocused(true)}
        onBlur={() => setIsFocused(false)}
        style={[styles.input, inputStyle]}
        contentStyle={styles.content}
        outlineStyle={styles.outline}
        testID={testID}
        {...props}
      />
      
      {(helperText || errorText) && (
        <HelperText 
          type={errorText ? 'error' : 'info'} 
          visible={!!(helperText || errorText)}
          style={styles.helperText}
        >
          {errorText || helperText}
        </HelperText>
      )}
      
      {maxLength && (
        <Text style={styles.charCount}>
          {value.length}/{maxLength}
        </Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 8,
  },
  input: {
    backgroundColor: '#FFFFFF',
  },
  content: {
    paddingHorizontal: 4,
  },
  outline: {
    borderRadius: 8,
    borderWidth: 1,
  },
  helperText: {
    paddingHorizontal: 12,
    fontSize: 12,
  },
  charCount: {
    fontSize: 12,
    color: '#757575',
    textAlign: 'right',
    paddingHorizontal: 12,
    paddingTop: 4,
  },
});

export default Input;