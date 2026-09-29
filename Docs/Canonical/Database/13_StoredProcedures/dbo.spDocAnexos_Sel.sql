SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spDocAnexos_Sel 'EACSR201305001BR'


CREATE	Procedure [dbo].[spDocAnexos_Sel] --'EAOXT201202004BR'
	
	@Processo	VarChar(16)

AS	

	Select 
		Item_Doc,
		TD.Nome_DC,
		Nome_Arquivo,
		Dt_Envio,
		dt_creacao,
		Nome_usuario
 	from 
		Doc_Anexos DA  With(nolock)
		Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
		left join Usuario U with(nolock) on U.cd_usuario = DA.cd_usuario_creacao
	where 
		Num_Proc=@Processo
order by 1




GO
