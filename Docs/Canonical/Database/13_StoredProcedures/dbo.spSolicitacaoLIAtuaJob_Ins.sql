SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spSolicitacaoLIAtuaJob_Ins]

as

/*
	Rotina automatica que inseri Numero da L.I. nos Jobs
	Anderson 06-03-2010
*/


Declare @Num_Proc Varchar(16)
Declare @Numero_Po_HIM	varchar(30)
Declare @DataPO	Datetime

Declare  cTemp cursor for
(
	select num_proc,num_li,dt_li from solicitacao_li SL
	Join LLP_Imp_Mar LLP on LLP.num_proc_lim=SL.num_proc
	Left Join PO_HIM LI on sl.num_proc=li.num_proc_him and sl.num_li=numero_po_him and id_dc=23
	where
		num_li is not null and numero_po_him is null
		and SL.id_status not in (11,12,7)

	UNION

	select num_proc,num_li,dt_li from solicitacao_li SL
	Join LLP_Imp_OUT LLP on LLP.num_proc_liO=SL.num_proc
	Left Join PO_HIO LI on sl.num_proc=li.num_proc_hiO and sl.num_li=numero_po_hiO and id_dc=23
	where
		num_li is not null and numero_po_hiO is null
		and SL.id_status not in (11,12,7)

	UNION

	select num_proc,num_li,dt_li from solicitacao_li SL
	Join LLP_Imp_AER LLP on LLP.num_proc_liA=SL.num_proc
	Left Join PO_HIA LI on sl.num_proc=li.num_proc_hiA and sl.num_li=numero_po_hiA and id_dc=23
	where
		num_li is not null and numero_po_hiA is null
		and SL.id_status not in (11,12,7)

	UNION
	
	select num_proc,num_li,dt_li from solicitacao_li SL
	Join HOUSE_IMP_AER HOU on HOU.num_proc_HIA=SL.num_proc
	Left Join PO_MASTER LI on sl.num_proc=li.num_proc_MASTER and sl.num_li=numero_po and id_dc=23
	where
		num_li is not null and numero_po is null
		and SL.id_status not in (11,12,7)


	UNION
	
	select num_proc,num_li,dt_li from solicitacao_li SL
	Join HOUSE_IMP_MAR HOU on HOU.num_proc_HIM=SL.num_proc
	Left Join PO_MASTER LI on sl.num_proc=li.num_proc_MASTER and sl.num_li=numero_po and id_dc=23
	where
		num_li is not null and numero_po is null
		and SL.id_status not in (11,12,7)

	
)

	Open cTEMP
	fetch next from cTemp into @Num_Proc,@Numero_po_him,@datapo
	
	While @@Fetch_Status=0
		Begin
			if len(@Num_Proc)=16 and left(@Num_Proc,2)='IM'
				Begin
					exec [spPOHIM_InsUpd] Null,@Numero_PO_HIM,@DataPO,@num_proc,23
				End
			if len(@Num_Proc)=16 and left(@Num_Proc,2)='IA'
				Begin
					exec [spPOHIA_InsUpd] Null,@Numero_PO_HIM,@DataPO,@num_proc,23
				End
			if len(@Num_Proc)=16 and left(@Num_Proc,2)='IO'
				Begin
					exec [spPOHIO_InsUpd] Null,@Numero_PO_HIM,@DataPO,@num_proc,23
				End
			if len(@num_proc)=14
				Begin
					exec spPOMaster_InsUpd Null,@Numero_PO_HIM,@DataPO,@num_proc,23,Null
				End
			fetch next from cTemp into @Num_Proc,@Numero_po_him,@datapo
		End

	close ctemp
	deallocate ctemp

GO
