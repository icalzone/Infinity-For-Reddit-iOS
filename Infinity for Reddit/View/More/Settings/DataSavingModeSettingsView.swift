//
// DataSavingModeSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI

struct DataSavingModeSettingsView: View {
    @AppStorage(DataSavingModeUserDefaultsUtils.dataSavingModeKey, store: .dataSavingMode) private var dataSavingMode: Int = 0
    @AppStorage(DataSavingModeUserDefaultsUtils.disableImagePreviewKey, store: .dataSavingMode) private var disableImagePreview: Bool = false
    @AppStorage(DataSavingModeUserDefaultsUtils.onlyDisablePreviewInVideoAndGIFKey, store: .dataSavingMode) private var onlyDisablePreviewInVideoAndGIF: Bool = false

    var body: some View {
        RootView {
            List {
                if dataSavingMode != 0 {
                    TogglePreference(
                        isEnabled: $disableImagePreview,
                        title: "Disable Image Preview in Data Saving Mode"
                    )
                    .listPlainItemNoInsets()

                    TogglePreference(
                        isEnabled: $onlyDisablePreviewInVideoAndGIF,
                        title: "Only Disable Preview in Video and Gif Posts"
                    )
                    .listPlainItemNoInsets()
                }
                
                PreferenceEntry(
                    title: "",
                    subtitle: "In data saving mode:\nPreview images are in lower resolution.\nVideo autoplay is disabled.",
                    icon: "exclamationmark.circle"
                ) {
                    // Empty action
                }
                .listPlainItemNoInsets()
                
                BarebonePickerPreference(
                    selected: $dataSavingMode,
                    items: DataSavingModeUserDefaultsUtils.dataSavingModeOptions,
                    title: "Data Saving Mode"
                ) { mode in
                    DataSavingModeUserDefaultsUtils.dataSavingModeOptionsText[mode]
                }
                .listPlainItemNoInsets()
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Data Saving Mode")
    }
}
