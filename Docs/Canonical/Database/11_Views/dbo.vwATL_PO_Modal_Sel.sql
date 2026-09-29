SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwATL_PO_Modal_Sel]
AS
select	
	H.Num_Proc_HEA		[JOB],	
	H.ID_PO_HEA			[Item],
	H.Numero_PO_HEA		[Customer Reference],	
	H.Data_PO_HEA		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HEA H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) 	on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario

union all 

select	
	H.Num_Proc_HEM		[JOB],	
	H.ID_PO_HEM			[Item],
	H.Numero_PO_HEM		[Customer Reference],	
	H.Data_PO_HEM		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HEM H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) 	on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario

union all 

select	
	H.Num_Proc_HEO		[JOB],	
	H.ID_PO_HEO			[Item],
	H.Numero_PO_HEO		[Customer Reference],	
	H.Data_PO_HEO		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HEO H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) 	on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario

union all

select	
	H.Num_Proc_HIA		[JOB],	
	H.ID_PO_HIA			[Item],
	H.Numero_PO_HIA		[Customer Reference],	
	H.Data_PO_HIA		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HIA H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) 	on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario

union all 

select	
	H.Num_Proc_HIM		[JOB],	
	H.ID_PO_HIM			[Item],
	H.Numero_PO_HIM		[Customer Reference],	
	H.Data_PO_HIM		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HIM H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) 	on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario

union all 

select	
	H.Num_Proc_HIO		[JOB],	
	H.ID_PO_HIO			[Item],
	H.Numero_PO_HIO		[Customer Reference],	
	H.Data_PO_HIO		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HIO H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) 	on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario


union all 

select	
	H.Num_Proc_HBO		[JOB],	
	H.ID_PO_HBO			[Item],
	H.Numero_PO_HBO		[Customer Reference],	
	H.Data_PO_HBO		[Date]					,
	H.ID_DC				[Client Doc Type Code],
	tc.Nome_DC			[Client Doc Type Name],
	H.cd_usuario		[User Code],
	Us.Nome_Usuario		[User Name],
	H.dt_ins			[Insert Date]
from PO_HBO H with (nolock)
left join Tipo_Doc_Cliente TC with (nolock) on TC.ID_DC  = H.ID_DC	
left join Usuario Us with (nolock) on Us.Cd_Usuario  = H.cd_usuario



GO
