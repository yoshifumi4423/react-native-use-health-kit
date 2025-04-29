import { resolve, join } from 'path';
import escape from 'escape-string-regexp';
import { getDefaultConfig, mergeConfig } from '@react-native/metro-config';
import blockList from 'metro-config/src/defaults/exclusionList';
import { peerDependencies } from '../package.json';

const root = resolve(__dirname, '..');
const peerModules = Object.keys({ ...peerDependencies });

const defaultConfig = getDefaultConfig(__dirname);

export default mergeConfig(defaultConfig, {
  projectRoot: __dirname,
  watchFolders: [root],

  resolver: {
    blockList: blockList(
      peerModules.map(m =>
        new RegExp(`^${escape(join(root, 'node_modules', m))}\\/.*$`),
      ),
    ),

    extraNodeModules: peerModules.reduce((acc, name) => {
      acc[name] = join(__dirname, 'node_modules', name);
      return acc;
    }, {}),
  },

  transformer: {
    assetRegistryPath: 'react-native/Libraries/Image/AssetRegistry',

    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
});
