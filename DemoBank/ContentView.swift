
//  Created by Nuriyeva Laman on 08.11.26


import SwiftUI

struct ContentView: View {

    @State private var customerId = ""
    @State private var pin = ""
    @State private var isLoggedIn = false
    @State private var selectedTab = 0
    @State private var showBalance = true
    @State private var showTransfer = false
    @State private var showSuccess = false
    @State private var cardFrozen = false
    @State private var cardFlipped = false

    @State private var balance = 12450.00

    private let blue = Color(red: 0.20, green: 0.40, blue: 0.95)
    private let dark = Color(red: 0.04, green: 0.08, blue: 0.17)

    var body: some View {
        ZStack {
            if isLoggedIn {
                mainApplication
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                loginScreen
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.5), value: isLoggedIn)
        .preferredColorScheme(.light)
    }

    // MARK: LOGIN

    var loginScreen: some View {
        ZStack {
            LinearGradient(
                colors: [dark, Color(red: 0.10, green: 0.22, blue: 0.48)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(blue.opacity(0.3))
                .frame(width: 280)
                .blur(radius: 60)
                .offset(x: 140, y: -300)

            VStack(spacing: 25) {

                Spacer()

                Image(systemName: "building.columns.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
                    .padding(25)
                    .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 25))
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }

                VStack(spacing: 8) {
                    Text("DemoBank")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Banking made smarter.")
                        .foregroundStyle(.white.opacity(0.65))
                }

                Spacer()

                VStack(alignment: .leading, spacing: 18) {

                    Text("Welcome back!")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("Sign in to continue")
                        .foregroundStyle(.white.opacity(0.65))

                    VStack(spacing: 14) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundStyle(.white.opacity(0.7))

                            TextField("Customer ID", text: $customerId)
                                .accessibilityIdentifier("customerIdField")
                                .foregroundStyle(.white)
                                .tint(.white)
                        }
                        .padding()
                        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))

                        HStack {
                            Image(systemName: "lock")
                                .foregroundStyle(.white.opacity(0.7))

                            SecureField("PIN Code", text: $pin)
                                .accessibilityIdentifier("pinField")
                                .keyboardType(.numberPad)
                                .foregroundStyle(.white)
                                .tint(.white)
                        }
                        .padding()
                        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                    }

                    Button {
                        guard !customerId.isEmpty && !pin.isEmpty else { return }

                        withAnimation {
                            isLoggedIn = true
                        }
                    } label: {
                        HStack {
                            Text("Sign In")
                            Image(systemName: "arrow.right")
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(dark)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("loginButton")

                    Text("Demo credentials: any non-empty ID and PIN")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                Text("SECURE DIGITAL BANKING")
                    .font(.caption2.bold())
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(28)
        }
    }

    // MARK: MAIN APPLICATION

    var mainApplication: some View {
        VStack(spacing: 0) {

            Group {
                switch selectedTab {
                case 0:
                    homeScreen
                case 1:
                    cardsScreen
                case 2:
                    transferScreen
                default:
                    profileScreen
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            bottomNavigation
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
        .sheet(isPresented: $showTransfer) {
            transferSheet
                .presentationDetents([.medium, .large])
        }
        .alert("Transfer Successful!", isPresented: $showSuccess) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("Your demo transaction has been completed successfully.")
        }
    }

    // MARK: HOME

    var homeScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("GOOD MORNING 👋")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)

                        Text("Hello, \(customerId)")
                            .font(.title2.bold())
                    }

                    Spacer()

                    Image(systemName: "bell.badge")
                        .font(.title2)
                        .foregroundStyle(dark)
                        .padding(12)
                        .background(.white, in: Circle())
                        .accessibilityIdentifier("notificationButton")
                }

                // Balance Card

                VStack(alignment: .leading, spacing: 18) {

                    HStack {
                        Text("TOTAL BALANCE")
                            .font(.caption.bold())
                            .tracking(1)

                        Spacer()

                        Button {
                            withAnimation {
                                showBalance.toggle()
                            }
                        } label: {
                            Image(systemName: showBalance ? "eye" : "eye.slash")
                        }
                        .accessibilityIdentifier("balanceVisibilityButton")
                    }
                    .foregroundStyle(.white.opacity(0.8))

                    Text(showBalance
                         ? String(format: "%.2f AZN", balance)
                         : "••••••••")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("balanceLabel")

                    HStack {
                        Label("+ 8.5%", systemImage: "arrow.up.right")
                            .foregroundStyle(.green)

                        Text("compared to last month")
                            .foregroundStyle(.white.opacity(0.65))
                            .font(.caption)

                        Spacer()

                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                    }
                    .font(.caption)
                }
                .padding(23)
                .background {
                    LinearGradient(
                        colors: [blue, Color(red: 0.12, green: 0.22, blue: 0.60)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: blue.opacity(0.25), radius: 15, y: 8)

                // Quick Actions

                VStack(alignment: .leading, spacing: 15) {
                    Text("Quick Actions")
                        .font(.title3.bold())

                    HStack(spacing: 12) {
                        quickAction("Transfer", icon: "arrow.left.arrow.right") {
                            showTransfer = true
                        }

                        quickAction("Cards", icon: "creditcard") {
                            selectedTab = 1
                        }

                        quickAction("History", icon: "clock.arrow.circlepath") {
                            selectedTab = 2
                        }

                        quickAction("Profile", icon: "person") {
                            selectedTab = 3
                        }
                    }
                }

                // Recent Transactions

                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Text("Recent Transactions")
                            .font(.title3.bold())

                        Spacer()

                        Button("See All") {
                            selectedTab = 2
                        }
                        .font(.caption.bold())
                        .foregroundStyle(blue)
                    }

                    transactionRow(
                        "Coffee House",
                        category: "Food & Drinks",
                        amount: "-8.50 AZN",
                        icon: "cup.and.saucer.fill",
                        positive: false
                    )

                    transactionRow(
                        "Salary Payment",
                        category: "Income",
                        amount: "+2,500 AZN",
                        icon: "arrow.down.left",
                        positive: true
                    )

                    transactionRow(
                        "Market",
                        category: "Shopping",
                        amount: "-45.90 AZN",
                        icon: "basket.fill",
                        positive: false
                    )
                }
            }
            .padding(22)
        }
        .accessibilityIdentifier("homeScreen")
    }

    // MARK: QUICK ACTION

    func quickAction(
        _ title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(blue)
                    .frame(width: 55, height: 55)
                    .background(blue.opacity(0.09), in: RoundedRectangle(cornerRadius: 17))

                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(dark)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: TRANSACTION ROW

    func transactionRow(
        _ title: String,
        category: String,
        amount: String,
        icon: String,
        positive: Bool
    ) -> some View {
        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(blue)
                .frame(width: 48, height: 48)
                .background(blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 5) {
                Text(title).fontWeight(.semibold)
                Text(category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(amount)
                .fontWeight(.bold)
                .foregroundStyle(positive ? .green : dark)
        }
        .padding(13)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .contain)
    }

    // MARK: CARDS

    var cardsScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                Text("My Cards")
                    .font(.largeTitle.bold())

                Button {
                    withAnimation(.spring()) {
                        cardFlipped.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.05, green: 0.10, blue: 0.25),
                                        blue
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        VStack(alignment: .leading, spacing: 25) {
                            HStack {
                                Text("DemoBank")
                                    .font(.title2.bold())

                                Spacer()

                                Image(systemName: "wave.3.right")
                                    .font(.title)
                            }

                            if cardFlipped {
                                Text("DEMO CARD")
                                    .font(.title2.bold())
                                Text("Cardholder: \(customerId)")
                            } else {
                                Image(systemName: "simcard.fill")
                                    .font(.largeTitle)

                                Text("**** **** **** 4829")
                                    .font(.title2.monospaced())
                            }

                            HStack {
                                Text("VISA")
                                    .font(.title.bold().italic())

                                Spacer()

                                Text(cardFrozen ? "FROZEN" : "ACTIVE")
                                    .font(.caption.bold())
                            }
                        }
                        .foregroundStyle(.white)
                        .padding(25)
                    }
                    .frame(height: 220)
                    .rotation3DEffect(
                        .degrees(cardFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .shadow(color: blue.opacity(0.2), radius: 15, y: 8)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("bankCard")

                Button {
                    withAnimation {
                        cardFrozen.toggle()
                    }
                } label: {
                    Label(
                        cardFrozen ? "Unfreeze Card" : "Freeze Card",
                        systemImage: cardFrozen ? "lock.open" : "snowflake"
                    )
                    .fontWeight(.bold)
                    .foregroundStyle(cardFrozen ? .green : .red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white, in: RoundedRectangle(cornerRadius: 15))
                }
                .accessibilityIdentifier("freezeCardButton")

                Text("Card Settings")
                    .font(.title3.bold())

                Label("Online payments", systemImage: "globe")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white, in: RoundedRectangle(cornerRadius: 15))

                Label("Contactless payments", systemImage: "wave.3.right")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white, in: RoundedRectangle(cornerRadius: 15))
            }
            .padding(22)
        }
    }

    // MARK: TRANSFERS

    var transferScreen: some View {
        VStack(spacing: 25) {
            Text("Transfers")
                .font(.largeTitle.bold())

            Image(systemName: "arrow.left.arrow.right.circle.fill")
                .font(.system(size: 75))
                .foregroundStyle(blue)

            Text("Send money easily")
                .font(.title2.bold())

            Text("Transfer funds between accounts or to another card.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                showTransfer = true
            } label: {
                Label("New Transfer", systemImage: "plus.circle.fill")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(blue, in: RoundedRectangle(cornerRadius: 15))
            }
            .accessibilityIdentifier("newTransferButton")

            Spacer()
        }
        .padding(25)
        .padding(.top, 35)
    }

    // MARK: TRANSFER SHEET

    var transferSheet: some View {
        TransferView(balance: balance) { amount in
            balance -= amount
            showSuccess = true
        }
    }

    // MARK: PROFILE

    var profileScreen: some View {
        VStack(spacing: 25) {

            Text("My Profile")
                .font(.largeTitle.bold())

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 85))
                .foregroundStyle(blue)

            Text(customerId)
                .font(.title2.bold())

            profileRow("Personal Information", icon: "person.text.rectangle")
            profileRow("Security Settings", icon: "lock.shield")
            profileRow("Notifications", icon: "bell")

            Button(role: .destructive) {
                customerId = ""
                pin = ""
                isLoggedIn = false
                selectedTab = 0
            } label: {
                Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white, in: RoundedRectangle(cornerRadius: 15))
            }
            .accessibilityIdentifier("logoutButton")

            Spacer()
        }
        .padding(25)
        .padding(.top, 25)
    }

    func profileRow(_ title: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
    }

    // MARK: BOTTOM NAVIGATION

    var bottomNavigation: some View {
        HStack {
            tabButton("Home", icon: "house.fill", index: 0)
            tabButton("Cards", icon: "creditcard.fill", index: 1)
            tabButton("Transfer", icon: "arrow.left.arrow.right", index: 2)
            tabButton("Profile", icon: "person.fill", index: 3)
        }
        .padding(.top, 13)
        .padding(.bottom, 8)
        .background(.white)
    }

    func tabButton(_ title: String, icon: String, index: Int) -> some View {
        Button {
            withAnimation(.spring()) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 19))

                Text(title)
                    .font(.caption2.bold())
            }
            .foregroundStyle(selectedTab == index ? blue : .gray)
            .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier("tab\(title)")
    }
}

// MARK: TRANSFER FORM

struct TransferView: View {

    let balance: Double
    let onTransfer: (Double) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var recipient = ""
    @State private var amount = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 22) {

                Text("New Transfer")
                    .font(.largeTitle.bold())

                Text("Recipient card number")
                    .font(.headline)

                TextField("0000 0000 0000 0000", text: $recipient)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityIdentifier("recipientField")

                Text("Amount (AZN)")
                    .font(.headline)

                TextField("0.00", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityIdentifier("transferAmountField")

                Text("Available balance: \(balance, specifier: "%.2f") AZN")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button {
                    let normalized = amount.replacingOccurrences(of: ",", with: ".")
                    guard let value = Double(normalized),
                          !recipient.isEmpty,
                          value > 0,
                          value <= balance else { return }

                    onTransfer(value)
                    dismiss()
                } label: {
                    Text("Confirm Transfer")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("confirmTransferButton")

                Spacer()
            }
            .padding(25)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
