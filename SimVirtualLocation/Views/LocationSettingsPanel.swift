//
//  LocationSettingsPanel.swift
//  SimVirtualLocation
//
//  Created by Sergey Shirnin on 18.04.2022.
//

import SwiftUI

struct LocationSettingsPanel: View {
    @EnvironmentObject var locationController: LocationController
    
    var body: some View {
        VStack {
            GroupBox {
                Picker("Points mode", selection: $locationController.pointsMode) {
                    Text("Single").tag(LocationController.PointsMode.single)
                    Text("Two").tag(LocationController.PointsMode.two)
                }.pickerStyle(.segmented)

                Button(action: {
                    locationController.setCurrentLocation()
                }, label: {
                    Text("Set to current location").frame(maxWidth: .infinity)
                })

                HStack {
                    Button(action: {
                        locationController.setSelectedLocation()
                    }, label: {
                        Text("Set to A").frame(maxWidth: .infinity)
                    })
                    Button(action: {
                        locationController.simulatePoint()
                    }, label: {
                        Text("Simulate to A").frame(maxWidth: .infinity)
                    })
                }
                
                HStack {
                    Button(action: {
                        locationController.setSelectedLocation(toBPoint: true)
                    }, label: {
                        Text("Set to B").frame(maxWidth: .infinity)
                    })
                    Button(action: {
                        locationController.simulatePoint(toBPoint: true)
                    }, label: {
                        Text("Simulate to B").frame(maxWidth: .infinity)
                    })
                }

                Button(action: {
                    locationController.makeRoute()
                }, label: {
                    Text("Make route").frame(maxWidth: .infinity)
                })

                Button(action: {
                    locationController.simulateRoute()
                }, label: {
                    Text("Simulate route").frame(maxWidth: .infinity)
                })

                Button(action: {
                    locationController.simulateFromAToB()
                }, label: {
                    Text("Simulate from A to B").frame(maxWidth: .infinity)
                })

                Button(action: {
                    locationController.stopSimulation()
                }, label: {
                    Text("Stop simulation").frame(maxWidth: .infinity)
                })
            }

            GroupBox {
                VStack(alignment: .leading) {
                    Slider(value: $locationController.speed, in: 5...200, step: 5) {
                        Text("Speed")
                    }
                    Text("\(Int(locationController.speed.rounded(.up))) km/h")
                }
            }
            
            GroupBox {
                Picker("Location update frequency", selection: $locationController.timeScale) {
                    Text("250ms").tag(0.25)
                    Text("500ms").tag(0.5)
                    Text("1s").tag(1.0)
                    Text("2s").tag(2.0)
                }.pickerStyle(.segmented).disabled(locationController.isSimulating)
            }

            Spacer()

            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Избранные маршруты")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    if locationController.favoriteRoutes.isEmpty {
                        Text("Нет сохраненных маршрутов")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(Array(locationController.favoriteRoutes.enumerated()), id: \.offset) { index, route in
                            HStack {
                                Text(route.name)
                                    .font(.caption)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Button("Загрузить") {
                                    locationController.loadFavoriteRoute(at: index)
                                }
                                .buttonStyle(.borderless)
                                .font(.caption)
                                
                                Button("Удалить") {
                                    locationController.removeFavoriteRoute(at: index)
                                }
                                .buttonStyle(.borderless)
                                .foregroundColor(.red)
                                .font(.caption)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    
                    if locationController.canSaveCurrentRoute {
                        Button("Сохранить текущий маршрут") {
                            locationController.showSaveRouteDialog = true
                        }
                        .buttonStyle(.borderless)
                        .font(.caption)
                        .padding(.top, 4)
                    }
                }
            }
            
            GroupBox {
                Button(action: {
                    locationController.reset()
                }, label: {
                    Text("Reset").frame(maxWidth: .infinity)
                })
            }
        }
        .sheet(isPresented: $locationController.showSaveRouteDialog) {
            SaveRouteDialog()
                .environmentObject(locationController)
        }
    }
}

struct SaveRouteDialog: View {
    @EnvironmentObject var locationController: LocationController
    @State private var routeName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Сохранить маршрут")
                .font(.headline)
            
            TextField("Название маршрута", text: $routeName)
                .textFieldStyle(.roundedBorder)
            
            HStack(spacing: 20) {
                Button("Отмена") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                
                buttonStyle
            }
        }
        .padding()
        .frame(width: 300)
    }
    
    @ViewBuilder
    private var buttonStyle: some View {
        if #available(macOS 12.0, *) {
            Button("Сохранить") {
                if !routeName.isEmpty {
                    locationController.saveCurrentRoute(name: routeName)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(routeName.isEmpty)
        } else {
            Button("Сохранить") {
                if !routeName.isEmpty {
                    locationController.saveCurrentRoute(name: routeName)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(.bordered)
            .disabled(routeName.isEmpty)
        }
    }
}

struct LocationSettingsPanel_Previews: PreviewProvider {
    static var previews: some View {
        LocationSettingsPanel()
    }
}
