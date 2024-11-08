export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'getAllSections' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, IDL.Text))],
        ['query'],
      ),
    'getSection' : IDL.Func([IDL.Text], [IDL.Opt(IDL.Text)], ['query']),
    'updateSection' : IDL.Func([IDL.Text, IDL.Text], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
