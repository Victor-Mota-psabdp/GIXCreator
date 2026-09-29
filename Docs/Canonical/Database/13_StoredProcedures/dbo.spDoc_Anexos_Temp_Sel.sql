SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spDoc_Anexos_Temp_Sel
--SP_HELP Doc_Anexos_Temp
CREATE Procedure [dbo].[spDoc_Anexos_Temp_Sel]--'2'
(
	@ID			BIGINT,
	--@ID_DC			varchar(200),
	--@DMS_Code		varchar(200),
	@Tipo		char(1)
)

as

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			--D.ID_House_Temp					[ID House Temp],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],
			
			D.Item_Doc						[Item],
			D.DMS_Code						[DMS Code],
			
			D.ID_DC							[Doc Type Code],
			tc.Nome_DC						[Doc Type],
			
			D.Nome_Arquivo					[File Name],
			
			D.cd_usuario					[User Code],
			Us.Nome_Usuario					[User],
			D.dt_ins						[Insert Date],
			convert(varchar(200),'Destination')		[Destination],
			convert(varchar(200),'Origin')			[Origin],
			convert(varchar(200),'Origin')			[File Name Destination]
			
		from Doc_Anexos_Temp D with(nolock)
		left join House_Temp H with(nolock) on H.ID =D.ID
		left join Tipo_Doc_Cliente TC	with(nolock) on TC.ID_DC  = D.ID_DC	
		left join Usuario Us with(nolock)	on Us.Cd_Usuario  = D.cd_usuario
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			--D.ID_House_Temp					[ID House Temp],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],
			
			D.Item_Doc						[Item],
			D.DMS_Code						[DMS Code],
			
			D.ID_DC							[Doc Type Code],
			tc.Nome_DC						[Doc Type],
			
			D.Nome_Arquivo					[File Name],
			
			D.cd_usuario					[User Code],
			Us.Nome_Usuario					[User],
			D.dt_ins						[Insert Date],
			
			convert(varchar(200),'Destination')		[Destination],
			convert(varchar(200),'Origin')			[Origin],
			convert(varchar(200),'Origin')			[File Name Destination]
		from Doc_Anexos_Temp D with(nolock)
		left join House_Temp H with(nolock) on H.ID =D.ID
		left join Tipo_Doc_Cliente TC with(nolock)	on TC.ID_DC  = D.ID_DC	
		left join Usuario Us	with(nolock) on Us.Cd_Usuario  = D.cd_usuario
		where
			H.ID = @ID
	End

GO
