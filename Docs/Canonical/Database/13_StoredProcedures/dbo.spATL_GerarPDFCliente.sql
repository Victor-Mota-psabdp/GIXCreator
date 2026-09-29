SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_GerarPDFCliente] --'GRUPO OXITENO','E','01-01-2013','01-30-2013'

	@Cliente as varchar(30),
	@Modal as char(1),
	@DataInicio as datetime,
	@DataFinal as datetime
	
AS

Declare @cd_cliente as varchar(30)

	Set @cd_Cliente = (select G.Grupo from pessoa P join grupo G on G.cd_pes_grupo = P.cd_pes where P.apelido = @Cliente)

select 
	nome_arquivo, 
	da.Num_Proc + '_' + Smart_Doc + '.pdf' NOME_DOC, 
	substring(da.num_proc,3,3) 
		+ '\' + left(da.Num_Proc,1) 
			+ '\' + 
				replace(isnull(HEA.Numero_PO_HEA,isnull(HEM.Numero_PO_HEM,isnull(HEO.Numero_PO_HEO,isnull(HIM.Numero_PO_HIM,isnull(HIA.Numero_PO_HIA,HIO.Numero_PO_HIO))))),' ','')  Pasta 
	from tarefas_processos	TP	with(nolock)
	join doc_anexos			DA	with(nolock) on DA.num_proc = TP.num_proc
	Join Tipo_DoC_Cliente	TC	with(nolock) on TC.id_dc=DA.id_dc
	left join PO_HEA		HEA with(nolock) on HEA.num_proc_hea = TP.num_proc  and HEA.ID_DC =3
	left join PO_HEM		HEM with(nolock) on HEM.num_proc_hem = TP.num_proc  and HEM.ID_DC =3
	left join PO_HEO		HEO with(nolock) on HEO.num_proc_heo = TP.num_proc  and HEO.ID_DC =3
	left join PO_HIM		HIM with(nolock) on HIM.num_proc_him = TP.num_proc  and HIM.ID_DC =3
	left join PO_HIA		HIA with(nolock) on HIA.num_proc_hia = TP.num_proc  and HIA.ID_DC =3
	left join PO_HIO		HIO with(nolock) on HIO.num_proc_hio = TP.num_proc  and HIO.ID_DC =3	
where	
	dt_Conclusao between @DataInicio and @DataFinal 
	And Smart_Doc Is Not Null
	and id_Task=4 
	and TP.num_proc like (@modal + '%' + @cd_cliente + '%')
	




GO
