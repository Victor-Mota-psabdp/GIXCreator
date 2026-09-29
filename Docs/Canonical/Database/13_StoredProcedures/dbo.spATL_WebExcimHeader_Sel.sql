SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_WebExcimHeader_Sel]
 (
 @Num_Proc varchar(16)
)
as
select 
LLP.Num_Proc_Lim [BDP Ref.], 
Agente.Nome_Raz_Soc [Partner], 
HOU.HAWB_HIM [ShipmentNumber],
CustomerPO.Numero_PO_HIM [PurchaseOrderNumber],
'Carrier' [Reponsibility],
'Ocean' [MethodofTransportation],
'Primary'[LegType],
HOU.Navio_HIM [Vessel Name],
TCON.Nome_Tp_Cont [EquipmentDescription],
Substring(CONM.Num_Cont_IM,1,4) [EquipmentInitial],
dbo.FRemoveCaracteresEspeciais(Substring(CONM.Num_Cont_IM,5,10)) [EquipmentNumber],
Qtd_Vol_IM [EquipamentTotalPackages],
convert(CHAR(10),LLP.ATD_Lim,112) [DateSailingConfirmed],
convert(CHAR(10),LLP.ATA_Lim,112)[ActUnloadedFromVesselDate],
convert(CHAR(10),LLP.ETD_Lim,112) [EstPortOfExistDate],
convert(CHAR(10),LLP.ETA_Lim,112) [EstimatedPortofDischargeDate]

 from LLP_Imp_Mar as LLP
Left Join House_Imp_Mar as HOU on LLP.Num_Proc_Lim = HOU.Num_Proc_Him
Left Join Job_Imp_Mar as JOB on LLP.Num_Proc_Lim = JOB.Num_Proc_Him
Left Join Pessoa as Agente on JOB.Cd_Agente = Agente.Cd_Pes
Left Join PO_Him as CustomerPO on LLP.Num_proc_Lim = CustomerPO.Num_Proc_Him and ID_DC = 9
Left Join Container_Hou_Imp_Mar as CONH on LLP.Num_proc_LIM = CONH.Num_Proc_Him
Left Join Container_MAS_Imp_Mar as CONM on CONH.Num_proc_MIM = CONM.Num_Proc_Mim and CONH.Item_Cont_IM = CONM.Item_Cont_IM
Left Join Tipo_Container as TCON on CONM.Cd_Tp_Cont = TCON.Cd_Tp_Cont
Left Join Volume_Imp_Mar as VOL on CONH.Num_proc_HIM = VOL.Num_Proc_Him and VOL.Item_Cont_IM = CONH.Item_Cont_IM
where LLP.Num_Proc_Lim = @Num_Proc-- substring(LLP.Num_Proc_Lim,3,3) = 'EXC' --and CustomerPO.Numero_PO_HIM = '44140'
GO
