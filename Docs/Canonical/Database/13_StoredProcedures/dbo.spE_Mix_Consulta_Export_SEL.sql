SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--116
--select * from E_Mix_Consulta_Tipo
--select * from Emix_De_Para_Parametro
CREATE Procedure [dbo].[spE_Mix_Consulta_Export_SEL]
			
AS

	select 
		'102'								[id_cliente],
		'140'								[id_integracao],
		'1a28c0af0dd545f0d7bd20a0d5c92d7f'	[contra_senha],
		C.id,
		[id_servico],	
		[id_empresa],
		[id_cnpj],
		C.id_consulta_tipo,
		[id_parametro_grupo],
		[id_parametro_tipo],
		[valor],
		C.num_proc,		
		--antes tinha uma alteração para enviar como 8 ou 9, o emix mudou pra enviar do jeito certo q eh o 
		--[id_parametro_grupo] = 13,
		[id_parametro_grupo] ID_Recuperacao
	from E_Mix_Consulta	C with(nolock)
		Left Join E_MIX_XML E with(nolock) on E.id=C.id		
	where dt_ins > GETDATE() -120
	and E.Num_Proc is null 
	and LEFT(C.Num_Proc,1) = 'E'
OPTION(HASH JOIN)	

GO
