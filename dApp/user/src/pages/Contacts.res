@react.component
let make = () => {
  let (addContact, setAddContact) = React.useState(_ => false)
  <div className="container max-w-3xl mx-auto">
    {addContact ? <AddContact openModal={setAddContact} /> : React.null}
    <div className="flex justify-between">
      <Heading> {"Contacts"->React.string} </Heading>
      <button
        onClick={_ => setAddContact(_ => true)}
        className="mt-3 w-full inline-flex justify-center border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
        {"Add contact"->React.string}
      </button>
    </div>
    <ContactsTable />
  </div>
}
