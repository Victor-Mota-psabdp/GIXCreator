SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Doc_Anexos_Temp
--spATL_Doc_Anexos_Temp_Sel '','','','','I'

CREATE Procedure [dbo].[spATL_Doc_Anexos_Temp_Sel]
(
	@ID			BIGINT,
	@Item_Doc	Int,
	@DMS_Code	varchar(200),
	@Num_Proc varchar(16),
	@Tipo		char(1)
)

as

if @Tipo = 'I'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		--D.Num_Proc IS NULL	
		--and 
		DA.dt_creacao is null
		and D.dt_ins >= '2020-12-09'
	--ORDER BY
	--	D.Intl_Reference,D.Item_Doc
	End

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
	--	select 
	--		convert(varchar(25),'Saved')	[Status],
	--		D.ID							[ID],
	--		--D.ID_House_Temp					[ID House Temp],
	--		D.ID_Req						[ID Req],
	--		D.Intl_Reference				[Intl Reference],
	--		H.Num_Proc						[JOB],
			
	--		D.Item_Doc						[Item],			
			
	--		D.ID_DC							[Doc Type Code],
	--		TC.Nome_DC						[Doc Type Name],

	--		D.DMS_Code						[DMS Document Type Code],
	--		DMS.Document_Type_Name			[DMS Document Type Name],
	--		DMS.ID_DC						[DMS Doc Type Code],
	--		TCDMS.Nome_DC					[DMS Doc Type Name],
			
	--		D.Nome_Arquivo					[File Name],
			
	--		D.cd_usuario					[User Code],
	--		US.Nome_Usuario					[User Name],
	--		D.dt_ins						[Insert Date],
	--		convert(varchar(200),'Destination')	[Destination],
	--		convert(varchar(200),'Origin')		[Origin],
	--		convert(varchar(200),'Origin')		[File Name Destination]
			
	--	from Doc_Anexos_Temp D with(NOLOCK)
	--	left join House_Temp H with(NOLOCK) on H.ID =D.ID
	--	left join Tipo_Doc_Cliente TC	with(NOLOCK) on TC.ID_DC  = D.ID_DC	
	--	left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario
	--	join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code
	--	left join Tipo_Doc_Cliente TCDMS	with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC	
	--	left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.ID_DC
	--where
	--	d.Num_Proc IS NULL
	--	AND h.Num_Proc IS NOT NULL	
	--	and DA.Item_Doc is null
	--	and DMS.ID_DC is not null
	select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		--D.Num_Proc IS NULL and 
		DA.dt_creacao is null
		and D.dt_ins >= '2020-12-09'
	--ORDER BY
	--	D.Intl_Reference,D.Item_Doc
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		--D.Num_Proc IS NULL	and 
		DA.dt_creacao is null
		AND	D.ID = @ID		
	--ORDER BY 
	--	D.Intl_Reference,D.Item_Doc
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		--D.Num_Proc IS NULL	and 
		DA.dt_creacao is null
		AND	D.Item_Doc =@Item_Doc
		AND D.DMS_Code = @DMS_Code
		
	--ORDER BY 
	--	D.Intl_Reference,D.Item_Doc
	End


/*
ALTER Procedure [dbo].[spATL_Doc_Anexos_Temp_Sel]
(
	@ID			BIGINT,
	@Item_Doc	Int,
	@DMS_Code	varchar(200),
	@Num_Proc varchar(16),
	@Tipo		char(1)
)

as

if @Tipo = 'I'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		--D.Num_Proc IS not NULL	
		--and 
		DA.dt_creacao is null
		and D.dt_ins >= '2020-12-09'
		and d.num_proc = 'IMEVO202012010BR'
	ORDER BY
		D.Intl_Reference,D.Item_Doc
	End

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
	--	select 
	--		convert(varchar(25),'Saved')	[Status],
	--		D.ID							[ID],
	--		--D.ID_House_Temp					[ID House Temp],
	--		D.ID_Req						[ID Req],
	--		D.Intl_Reference				[Intl Reference],
	--		H.Num_Proc						[JOB],
			
	--		D.Item_Doc						[Item],			
			
	--		D.ID_DC							[Doc Type Code],
	--		TC.Nome_DC						[Doc Type Name],

	--		D.DMS_Code						[DMS Document Type Code],
	--		DMS.Document_Type_Name			[DMS Document Type Name],
	--		DMS.ID_DC						[DMS Doc Type Code],
	--		TCDMS.Nome_DC					[DMS Doc Type Name],
			
	--		D.Nome_Arquivo					[File Name],
			
	--		D.cd_usuario					[User Code],
	--		US.Nome_Usuario					[User Name],
	--		D.dt_ins						[Insert Date],
	--		convert(varchar(200),'Destination')	[Destination],
	--		convert(varchar(200),'Origin')		[Origin],
	--		convert(varchar(200),'Origin')		[File Name Destination]
			
	--	from Doc_Anexos_Temp D with(NOLOCK)
	--	left join House_Temp H with(NOLOCK) on H.ID =D.ID
	--	left join Tipo_Doc_Cliente TC	with(NOLOCK) on TC.ID_DC  = D.ID_DC	
	--	left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario
	--	join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code
	--	left join Tipo_Doc_Cliente TCDMS	with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC	
	--	left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.ID_DC
	--where
	--	d.Num_Proc IS NULL
	--	AND h.Num_Proc IS NOT NULL	
	--	and DA.Item_Doc is null
	--	and DMS.ID_DC is not null
	select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		D.Num_Proc IS NULL	
		and DA.dt_creacao is null
		and d.num_proc = 'IMEVO202012010BR'
	ORDER BY
		D.Intl_Reference,D.Item_Doc
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		D.Num_Proc IS NULL	
		and DA.dt_creacao is null
		AND	D.ID = @ID		
	ORDER BY 
		D.Intl_Reference,D.Item_Doc
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],			
			D.Item_Doc						[Item],	
			D.Nome_Arquivo					[File Name],
			D.cd_usuario					[User Code],
			D.Nome_Usuario					[User Name],
			D.dt_ins						[Insert Date],

			D.DMS_Code						[DMS Document Type Code],
			D.Document_Type_Name			[DMS Document Type Name],
			D.ID_DC							[DMS Doc Type Code],
			D.Nome_DC						[DMS Doc Type Name],

			D.ID_DC							[Doc Type Code],
			D.Nome_DC						[Doc Type Name],
	
			
			convert(varchar(200),'Destination')	[Destination],
			convert(varchar(200),'Origin')		[Origin],
			convert(varchar(200),'Origin')		[File Name Destination],

			DA.dt_creacao,
			Da.Item_Doc
			
		from vwATL_Doc_Anexos_Temp_Sel D with(NOLOCK)
		--join House_Temp H with(NOLOCK) on H.ID =D.ID
		--join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
		--join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC

		----left join Tipo_Doc_Cliente TC with(NOLOCK) on TC.ID_DC  = DMS.ID_DC	
		--left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario			
		left join Doc_Anexos DA	with(NOLOCK) on DA.Num_Proc = D.Num_Proc and DA.id_dc = D.id_dc
	where
		D.Num_Proc IS NULL	
		and DA.dt_creacao is null
		AND	D.Item_Doc =@Item_Doc
		AND D.DMS_Code = @DMS_Code
		
	ORDER BY 
		D.Intl_Reference,D.Item_Doc
	End

*/
GO
