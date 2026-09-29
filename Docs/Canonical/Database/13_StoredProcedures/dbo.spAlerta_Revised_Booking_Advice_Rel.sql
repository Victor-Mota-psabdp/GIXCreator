SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAlerta_Revised_Booking_Advice_Rel]

AS


--SET LANGUAGE Brazilian

	select distinct
		HOU.num_proc_hem			[JOB],
		MAS.Num_Proc_MEM			[JOB_Master],		
		(CASE  WHEN LLP.ATA_Lem is not null then
			'ARRIVAL NOTICE - ' + HOU.num_proc_hem + ' - Booking No.: ' + isnull(JOB.nr_reserva,'')
		else
			'REVISED BOOKING ADVICE - ' + HOU.num_proc_hem + ' - Booking No.: ' + isnull(JOB.nr_reserva,'') 
			END)	[Assunto],
			
		--'REVISED BOOKING ADVICE - ' + HOU.num_proc_hem + ' - Booking No.: ' + isnull(JOB.nr_reserva,'')	[Assunto],		
		
		'SHIPPER NAME: ' + isnull(SHP.nome_raz_soc,'') + '|' +
		'CNEE NAME ' + isnull(CON.nome_raz_soc,'') + '|' +		
		'REF. PO # ' + isnull([dbo].[fBusca_Docs_PO_Modal](HOU.num_proc_hem,1),'') + '||' +
		'BDP BOOKING NUMBER Nr.: ' + isnull(JOB.nr_reserva,'') + '|' + 
		
		'NO/SIZE/TYPE OF CONTAINERS: ' + '|' +	 
		isnull([dbo].[fBusca_Containers_Lacre_Tara](HOU.Num_Proc_HEM),'') + '||' +
		
		'Carrier: ' + isnull(Armador.Nome_Armador,'') + '|' +
		'Vessel/Voy No: ' + isnull(HOU.Navio_hem,'') + '/' + isnull(HOU.Viagem_hem,'') + '|' +
		--'Booking No.: ' + isnull(JOB.nr_reserva,'') + '||' + 
	
		'Loading at: ' + Org.nome_local + ' ' + isnull(CONVERT(VARCHAR(10), LLP.ETD_Lem, 101),'') + '|' +
		'Arriving:  ' + DES.nome_local + ' ' + isnull(CONVERT(VARCHAR(10), LLP.ETA_Lem, 101),'') + '||' +
		'Arrived: ' + isnull(CONVERT(VARCHAR(10), LLP.ATA_Lem, 101),'') + '||' +
			
		'Deadline Draft: ' + isnull(CONVERT(VARCHAR(10), LLP.DL_Draft_Lem, 101) + ' ' + CONVERT(VARCHAR(8),LLP.DL_Draft_Lem, 108),'') + '|' +
		'Deadline Carga: ' + isnull(CONVERT(VARCHAR(10), LLP.DL_Cargo_Lem, 101) + ' ' + CONVERT(VARCHAR(8),LLP.DL_Cargo_Lem, 108),'') + '|' +
		'Deadline VGM: ' + isnull(CONVERT(VARCHAR(10), LLP.DL_VGM_Lem, 101) + ' ' + CONVERT(VARCHAR(8),LLP.DL_VGM_Lem, 108),'')+ '||' +
		
		
		'Comentários : ' + isnull(replace(JOB.Obs_JEM,'''',' '),'') +  '|'	
		
		
		 --+ '|||||||||' +
		 --'Emails do shipper: ' + isnull([dbo].[fBusca_Emal_Comunicacao](HOU.cd_export_hem,'EM%'),'') + '||' +
		 --'Emails do shipper: ' + isnull([dbo].[fBusca_Emal_Comunicacao](mas.Cd_Consig_MEM,'AG%'),'') + '||' 
		
		[CorpoMSG],

		'thatiane.araujo@bdpint.com'								[ResponderPara],
		
		'thatiane.araujo@bdpint.com'								[CopyBDP],

		[dbo].[fBusca_Emal_Comunicacao](HOU.cd_export_hem,'EM%')	[Emails_Cliente],
		--'thatiane.araujo@bdpint.com'								[Emails_Cliente],
		
		SHP.Apelido													[Nome_Cliente],
		'Cliente: ' + SHP.Apelido + ' sem emails cadastrados, JOB: ' + HOU.num_proc_hem [CorpoMSG_Cliente],
		
	
		[dbo].[fBusca_Emal_Comunicacao](mas.Cd_Consig_MEM,'AG%')	[Emails_Cliente_Master],
		--'thatiane.araujo@bdpint.com'								[Emails_Cliente_Master],
		'Agente: ' + CLI.Apelido + ' sem emails cadastrados, JOB: ' + MAS.Num_Proc_MEM [CorpoMSG_Cliente_Master],
		CLI.Apelido													[Nome_Cliente_Master],
		
		' - Não Enviado'											[Assunto_CorpoMSG],
		
		EXC.Id_Tp_Alerta [Id_Tp_Alerta]
	from  Exchange_Alerta EXC with(nolock)
		join house_exp_mar Hou with(nolock) on EXC.Num_Proc = HOU.Num_Proc_HEM
		join LLP_Exp_MAR LLP with(nolock) on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		join JOB_Exp_MAR JOB with(nolock) on JOB.Num_Proc_HEM = HOU.Num_Proc_HEM
		join Master_Exp_Mar MAS with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
		join pessoa SHP	with(nolock) on SHP.cd_pes = HOU.cd_export_hem
		join pessoa CON	with(nolock) on CON.cd_pes = HOU.cd_consig_hem
		join pessoa CLI	with(nolock) on CLI.cd_pes = mas.Cd_Consig_MEM
		join Localidade Des	with(nolock) on DES.cd_local = HOU.cd_dst_HEM
		join Localidade Org	with(nolock) on Org.cd_local = HOU.cd_org_hem
		Left Join Armador Armador	with(nolock) on LLP.cd_armador_lem = Armador.cd_Armador	
	where
		EXC.dt_envio is null
		and EXC.Id_TP_Alerta = 1
		and HOU.Num_Proc_MEM <> 'JOB'

GO
