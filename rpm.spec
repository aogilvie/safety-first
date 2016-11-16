Name:           safety-first
Version:        0.1
Release:        1%{?dist}
Summary:        A tool for LV management
Source0:        sources.tar
BuildArch: noarch

License:        MIT
URL:            https://github.com/aogilvie/safety-first.git

Requires:       lvm2

%description
A tool for LV management

%prep
%setup -c %{name} -q

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/%{name}
cp -R . $RPM_BUILD_ROOT/opt/%{name} > /dev/null

%files
/opt/%{name}

%doc

%changelog
