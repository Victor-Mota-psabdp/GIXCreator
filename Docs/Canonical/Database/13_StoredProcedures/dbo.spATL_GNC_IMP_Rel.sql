SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_GNC_IMP_Rel] -- exec spATL_GNC_IMP_Rel 'GRUPO ALL','2023-05-01','2023-05-22'

	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
As	

	select
		HG.Dt_Emis										[DT. REGISTRO],
		HG.Modal										[MODAL],
		HGI.HSGProcesso									[BDP REF.],
		Consignee.Nome_Raz_Soc							[CONSIGNEE],
		case 
		WHEN len(Consignee.Num_CPF_CNPJ)>14 then substring(Consignee.Num_CPF_CNPJ,2,2) + '.' + substring(Consignee.Num_CPF_CNPJ,4,3) + '.' + substring(Consignee.Num_CPF_CNPJ,7,3) + '/' + substring(Consignee.Num_CPF_CNPJ,10,4) + '-' + substring(Consignee.Num_CPF_CNPJ,14,2)    
		ELSE  substring(Consignee.Num_CPF_CNPj,1,2) + '.' + substring(Consignee.Num_CPF_CNPj,3,3) + '.' + substring(Consignee.Num_CPF_CNPj,6,3) + '/' + substring(Consignee.Num_CPF_CNPj,9,4) + '-' + substring(Consignee.Num_CPF_CNPj,13,2)    End [CNPJ],
	  	
		left(dbo.fBusca_Docs_PO_Modal(hg.Num_Proc,1),500)[N. PO],	
		tc.Nome_Tp_Carga								[TP. CARGA],
		left(dbo.fBusca_Docs_PO_Modal(HG.Num_Proc,'23'),400) [LICENÇA IMP.],
		cast(dbo.fBusca_TipoDocCliente('D',HG.Num_Proc,23) as datetime) [DT. LI],
		T20.Dt_CONCLUSAO								[DT. DEF LI],
		HG.ATA											[ATA DATE],		
		T.Nome_Terminal									[TERMINAL],
		T15.DT_CONCLUSAO								[PRESENÇA DE CARGA],
		DI.Numero_PO									[N. ENTRADA],
		T172.DT_CONCLUSAO								[REGISTRO DE DI],
		HG.Canal										[CANAL],
		T4.Dt_Conclusao									[DT. DESEMBARAÇO],
		T164.Dt_Conclusao								[DT. MADEIRA LIBERADA],
		Trucker.Nome_Raz_Soc							[INLAND TRUCKER],
		T7.DT_Conclusao									[ENTREGA DOCS PARA TRANSPORTE],	
		DATEDIFF(day,HG.ATA,T7.Dt_Conclusao)			[DIF. DATAS],
				

		(Case when hg.Tp_Carga = '1' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 8 then 'LATE' else
		(Case when hg.Tp_Carga = '1' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 8 then 'ON TIME' else
		(Case when hg.Tp_Carga = '2' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 10 then 'LATE' else
		(Case when hg.Tp_Carga = '2' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 10 then 'ON TIME' else 
		(Case when hg.Tp_Carga = '3' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 8 then 'LATE' else
		(Case when hg.Tp_Carga = '3' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 8 then 'ON TIME' else

		(Case when hg.Modal = 'Air Import' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 5 then 'LATE' else 
		(Case when hg.Modal = 'Air Import' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 5 then 'ON TIME' else

		(Case when hg.Modal = 'Other Import' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) > 7 then 'LATE' else
		(Case when hg.Modal = 'Other Import' and DATEDIFF(day,HG.ATA,T7.Dt_Conclusao) <= 7 then 'ON TIME' End) End) End) End) End) End) End) End) End) End) [DELAY],
		
		TPNC.Cd_NC										[COD. GNC],
		HGI.HSGData										[REGISTRO GNC],
		TPNC.Parte_Resp									[RESP. PART],
		TPNC.Descricao_nC								[NC DESC],
		TPNC.Descricao_NC_ENG							[NC DESC ENG],
		TPNC.Descricao_NC_PTG							[NC DESC PTG],
		hgi.hsddescricao								[HISTORICO GNC],
		HGI.HSGDataFU									[DT. PREVISAO],
		HGI.Disp_Cliente								[VISIVEL P/ CLIENTE]
		
		

	from
		vwHouse_Imp HG	with(nolock)
		join Pessoa Consignee with(nolock) on Consignee.cd_pes=Cd_Consig
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes= HG.Cd_Consig
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		INNER join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		left join Pessoa CS with(nolock) on HG.Cd_Consig = CS.Cd_Pes 
		left join Tipo_Carga TC on tc.Cd_Tp_Carga = hg.Tp_Carga
		Left Outer Join Tarefas_processos	T7	on HG.Num_Proc = T7.Num_proc and T7.ID_Task = 7
		Left Outer Join Tarefas_processos	T15	on HG.Num_Proc = T15.Num_proc and T15.ID_Task = 15
		Left Outer Join Tarefas_processos	T172	on HG.Num_Proc = T172.Num_proc and T172.ID_Task = 172
		Left Outer Join Tarefas_processos	T4	on HG.Num_Proc = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T164	on HG.Num_Proc = T164.Num_proc and T164.ID_Task = 164
		Left Outer Join Tarefas_processos	T20	on HG.Num_Proc = T20.Num_proc and T20.ID_Task = 20
		join Hist_Geral		HGI		with(nolock) on HG.Num_Proc    = HGI.HSGProcesso
		Join Tipo_NC_Cliente			TPNC on tpnc.Cd_NC = hgi.id_nc		
		Left Join Pessoa Trucker with(nolock) on HG.Cd_Transportadora=Trucker.cd_pes
		Left Join Terminal T with(nolock) on T.Cd_Terminal=HG.Cd_Terminal
		Left Join vwPO_ALL  di on di.num_proc=HG.num_proc and di.ID_DC=5

	where
		
		--HG.Modal = 'Other Import'
		--HG.Num_Proc LIKE '%IASWB2018%'
		HGI.HSGData between @DtInicial and @DtFinal
		and 
		(PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	--	order by hgi.HSGProcesso


GO
