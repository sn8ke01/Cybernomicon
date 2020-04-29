# Active Directory Overview
> 95% of Fortune 1000 companies use AD

- Active Directory (AD) stores information related to objects such as computers and users. It is a link between objects and values.  
- Authentication using Kerberos tickets.
- Non Windows devices, like Linux, can also authenticate to AD via RADIUS and LDAP.
- Many features of AD can be abused w/o ever going after CVEs or other patchable exploits.


## Components
**Domain Controller (DC)** a server with the AD DS server role installed that has been specifically promoted to domain controller.

- Host a copy of the AD DS directory store
- Provide authentication and authorization services
- Replicate updates to other domain controller in the domain forest
- Allow administrative access to manage user accounts and network resources

**Active Directory Data Store (AD DS)**  contains the database files and processes that store and manage directory information for users, services, and applications.

- Consists of the *Ntds.dit* file.  
  - <u>This is a *target file* during an assessment.</u> :boom:
  - It contains password hashes, along with *everything* contained in the AD data.
- Default location for all domain controllers is `%SystemRoot%\NTDS` folder
- Only Accessible through the DC process and protocols

**AD Schema** defines every type of object that can be stored in the directory.   It also enforces rules regarding object creation and configuration.

> The schema is the blueprint of Active Directory and schema defines what kinds of objects can exist in the Active Directory database and attributes of those objects.

<u>Example Schema</u>

| Object Types     | Function                                     | Examples               |
| ---------------- | -------------------------------------------- | ---------------------- |
| Class Object     | What objects can be created in the directory | - User<br />- Computer |
| Attribute Object | Info that can be attached to an object       | - Display Name         |

## Domain

**Domains** Used to group and manage object in an organization.

- An Administrative boundary for applying policies to groups and objects
- A replication boundary for data between domain controllers
- Authentication and authorization boundary that provides a way to limit the scope of access to resources.

## Trees

**Trees** hierarchy of domains in AD DS

- Share a contiguous namespace with the parent domain
- Can have additional child domains
- Default create a two-way transitive trust with other domains

## Forests

**Forests** a collection of one or more domain trees.

- Share common schema
- Share common configuration partition
- Share a common global catalogue to enable searching
- Enable trusts between all domains in the forest
- Share the Enterprise Admins and Schema Admins groups

## Organizational Units

**Organizational Units (OUs)** are Active Directory containers that can contain user, groups, computers, and  other OUs.

- Represent your organization hierarchically and logically
- Manage a collection of objects in a consistent way
- Delegate permissions to administer groups of objects
- Apply policies

## Trusts

**Trusts** provide the mechanism for users to gain access to resources in another domain.

- All domain in a forest trust all other domains in the forest.
- Trusts can be extended outside the forest

| Types of Trusts | Description                                                  | Diagram     |
| --------------- | ------------------------------------------------------------ | ----------- |
| Directional     | Trust direction flows from trusting domain to the trusteed domain | ^ <--> ^    |
| Transitive      | Relationship is extended beyond a two-domain trust to include other trusted domains | ^ <->^<-> ^ |

## Objects

**Objects** are what is contained within the OU. User, Group, printer, etc.

<u>*User*</u> enables network access for a user object

<u>*InetOrgPerson*</u> Similar to an account and used for compatibility w/other AD services

<u>*Contacts*</u> Used to assign email addresses to external  users.  *Does not enable network access*

*<u>Groups</u>* Simplifies the admin of access control

*<u>Computers</u>* Enables authentication and auditing of computer access to resources

<u>Printers</u> Used to simplify to process of locating and connecting to printers

*<u>Shared Folder</u>* Enables users to search for shared folder based on properties