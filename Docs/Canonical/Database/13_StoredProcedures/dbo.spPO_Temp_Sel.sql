SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from PO_Temp
--[spPO_Temp_Sel]42,'D'
CREATE Procedure [dbo].[spPO_Temp_Sel]--'2'
(
	@ID			BIGINT,
	@Tipo		char(1)
)

as

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			convert(varchar(25),'Saved') [Status],
			H.ID						[ID],
			H.ID_Req					[ID Req],
			H.Intl_Reference			[Intl Reference],
			--HOU.ID_House_Temp,
			H.Num_Proc					[JOB],
			
			H.ID_PO_Temp				[Item],
			H.Numero_PO_Temp			[Customer Reference],
			
			H.Data_PO_Temp				[Date]					,
			H.ID_DC						[Doc Type Code],
			tc.Nome_DC					[Doc Type],
			H.Name_Reference			[Doc Type XML],
			H.cd_usuario				[User Code],
			Us.Nome_Usuario				[User],
			H.dt_ins					[Insert Date]
		from PO_Temp H with(nolock)
		left join Tipo_Doc_Cliente TC with(nolock)	on TC.ID_DC  = H.ID_DC	
		left join Usuario Us	with(nolock) on Us.Cd_Usuario  = H.cd_usuario
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved') [Status],
			H.ID						[ID],
			H.ID_Req					[ID Req],
			H.Intl_Reference			[Intl Reference],
			--HOU.ID_House_Temp,
			H.Num_Proc					[JOB],
			
			H.ID_PO_Temp				[Item],
			H.Numero_PO_Temp			[Customer Reference],
			
			H.Data_PO_Temp				[Date]					,
			H.ID_DC						[Doc Type Code],
			tc.Nome_DC					[Doc Type],
			H.Name_Reference			[Doc Type XML],
			H.cd_usuario				[User Code],
			Us.Nome_Usuario				[User],
			H.dt_ins					[Insert Date]
		from PO_Temp H with(nolock)
		left join Tipo_Doc_Cliente TC with(nolock)	on TC.ID_DC  = H.ID_DC	
		left join Usuario Us with(nolock)	on Us.Cd_Usuario  = H.cd_usuario
		where
			H.ID = @ID
	End

GO
