SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Doc_Anexos_Temp
CREATE VIEW [dbo].[vwATL_Doc_Anexos_Temp_Sel]
AS
		Select			
			D.ID,
			D.ID_Req,
			D.Intl_Reference,
			H.Num_Proc,			
			D.Item_Doc,	
			D.Nome_Arquivo,
			D.cd_usuario,
			US.Nome_Usuario,
			D.dt_ins,

			D.DMS_Code,
			DMS.Document_Type_Name,
			DMS.ID_DC,
			TCDMS.Nome_DC
		from House_Temp  H with(NOLOCK)
			join Doc_Anexos_Temp D  with(NOLOCK) on H.ID =D.ID
			join Tipo_Doc_DMS DMS	with(NOLOCK) on DMS.DMS_Code  = D.DMS_Code		
			join Tipo_Doc_Cliente TCDMS with(NOLOCK) on TCDMS.ID_DC  = DMS.ID_DC	
			left join Usuario Us with(NOLOCK) on Us.Cd_Usuario  = D.cd_usuario
		Where 
			H.Num_Proc is not null

GO
