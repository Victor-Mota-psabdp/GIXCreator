SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_DocAnexos_Sel]-- 'EAOXT201202004BR'
	
	@Processo	VarChar(16)

AS	

--Select
--		'Saved'										[Status],
--		right('000' + convert(int,Item_Doc),3)		[Item],
--		right('000' + Convert(varchar(3),DA.ID_DC),3)	[ID_DC],
--		TD.Nome_DC									[Type Doc],
--		--right('000' + Convert(varchar(3),DA.ID_DC),3) + '-'+ TD.Nome_DC	[Type Doc],
--		convert(varchar(10),Dt_Envio,103)			[Sent Date],
--		Nome_Arquivo								[File],		
--		convert(varchar(10),dt_creacao,103)			[Creation Date],
--		Nome_usuario								[User],
--		''											[Origin],
--		''											[Destin]
-- 	from 
--		Doc_Anexos DA  With(nolock)
--		Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC
--		left join Usuario U on U.cd_usuario = DA.cd_usuario_creacao
--	where 
--		Num_Proc=@Processo and Num_Proc <> ''
--	order by 2
	
	Select
		'Saved'										[Status],
		right('000' + convert(int,Item_Doc),3)		[Item],
		TD.Nome_DC									[Type Doc],
		convert(varchar(10),Dt_Envio,103)			[Sent Date],
		Nome_Arquivo								[File],		
		convert(varchar(10),dt_creacao,103)			[Creation Date],
		Nome_usuario								[User],
		''											[Origin],
		''											[Destin]
 	from 
		Doc_Anexos DA				With(nolock)
		Join Tipo_Doc_Cliente TD	with(nolock) on TD.Id_DC = DA.Id_DC
		left join Usuario U			with(nolock)on U.cd_usuario = DA.cd_usuario_creacao
	where 
		Num_Proc=@Processo and Num_Proc <> ''
	order by 2

GO
