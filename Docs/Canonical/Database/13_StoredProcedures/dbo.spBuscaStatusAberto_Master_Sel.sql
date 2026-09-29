SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spBuscaStatusAberto_Master_Sel 'OUT'

--select  id_status,* from LLP_Master where num_proc_master='IAGRU202208009'
--select  id_status,* from vwHouse_Imp where Master='IACHI201911001'
--select  id_status,* from vwHouse_Exp where Master='IAVCP202202040'

CREATE Procedure [dbo].[spBuscaStatusAberto_Master_Sel]
(
	@Type Varchar(3)
)
AS


if @Type = 'A'
	BEGIN
		Select   
			isnull(MAS.ID_Status_Master,0) ID_Status_Master, 
			MAS.Num_Proc_Master, 
			HOU.ID_Status,
			HOU.Num_Proc,
				Convert(Datetime,MAS.Dt_Emis_Master, 103) Dt_Emis
			,Qtd_HAWB_Master
		from vwHouse_Imp HOU With (nolock)
			join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master		
		where 	
			Qtd_HAWB_Master = 1
			and isnull(MAS.ID_Status_Master,0) <> HOU.ID_Status
			and isnull(MAS.ID_Status_Master,0) <> 9 and HOU.ID_Status <> 9
			and Convert(Datetime,MAS.Dt_Emis_Master, 103) > '2022-01-01'

	Union All   

		Select   
			isnull(MAS.ID_Status_Master,0) ID_Status_Master, 
			MAS.Num_Proc_Master, 
			HOU.ID_Status,
			HOU.Num_Proc,
			Convert(Datetime,MAS.Dt_Emis_Master, 103) Dt_Emis
			,Qtd_HAWB_Master
		from vwHouse_Exp HOU With(nolock)  
			join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
		where 
			--HOU.Num_Proc = 'EASUR202210001BR' and
			Qtd_HAWB_Master = 1
			and isnull(MAS.ID_Status_Master,0) <> HOU.ID_Status
			and isnull(MAS.ID_Status_Master,0) <> 9 and HOU.ID_Status <> 9
			and Convert(Datetime,MAS.Dt_Emis_Master, 103) > '2022-01-01'	
		order by 2
	END
else
	BEGIN
		Select distinct 
			isnull(MAS.ID_Status_Master,0) ID_Status_Master, 
			MAS.Num_Proc_Master, 
			NULL ID_Status,
			NULL Num_Proc,
			Convert(Datetime,MAS.Dt_Emis_Master, 103) Dt_Emis
			,Qtd_HAWB_Master
		from vwHouse_Imp HOU With (nolock)
			join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master		
		where 	
			Qtd_HAWB_Master > 1
			and isnull(MAS.ID_Status_Master,0) <> HOU.ID_Status
			and isnull(MAS.ID_Status_Master,0) <> 9 and HOU.ID_Status <> 9
			and Convert(Datetime,MAS.Dt_Emis_Master, 103) > '2022-01-01'

	Union All   

		Select distinct
			isnull(MAS.ID_Status_Master,0) ID_Status_Master, 
			MAS.Num_Proc_Master, 
			NULL ID_Status,
			NULL Num_Proc,
			Convert(Datetime,MAS.Dt_Emis_Master, 103) Dt_Emis
			,Qtd_HAWB_Master
		from vwHouse_Exp HOU With(nolock)  
			join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
		where 
			Qtd_HAWB_Master > 1
			and isnull(MAS.ID_Status_Master,0) <> HOU.ID_Status
			and isnull(MAS.ID_Status_Master,0) <> 9 and HOU.ID_Status <> 9
			and Convert(Datetime,MAS.Dt_Emis_Master, 103) > '2022-01-01'	
		order by 2
	END


	/*if @Type = 'A'
	BEGIN
		Select   
			MAS.ID_Status_Master, 
			MAS.Num_Proc_Master, 
			HOU.ID_Status,
			HOU.Num_Proc,
			Convert(Datetime,HOU.Dt_Emis, 103) Dt_Emis
		from vwHouse_Imp HOU With (nolock)
			join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master		
		where 	
			MAS.ID_Status_Master<> HOU.ID_Status and 
			HOU.Master in 
			(
				Select HOU.Master from vwHouse_Imp HOU With(nolock)  
				join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
				where 
					--MAS.ID_Status_Master<> HOU.ID_Status and 
					Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
					and MAS.ID_Status_Master <> 9 and HOU.ID_Status <> 9	
				GROUP BY 
					HOU.Master
				HAVING 
					Count(*)= 1
			)

	Union All   

		Select   
			MAS.ID_Status_Master, 
			MAS.Num_Proc_Master, 
			HOU.ID_Status,
			HOU.Num_Proc,
			Convert(Datetime,HOU.Dt_Emis, 103) Dt_Emis
		from vwHouse_Exp HOU With(nolock)  
			join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
		where 
			MAS.ID_Status_Master<> HOU.ID_Status and
			HOU.Master in 
			(
				Select HOU.Master from vwHouse_Exp HOU With(nolock)  
				join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
				where 
					--MAS.ID_Status_Master<> HOU.ID_Status and 
					Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
					and MAS.ID_Status_Master <> 9 and HOU.ID_Status <> 9	
				GROUP BY 
					HOU.Master
				HAVING 
					Count(*)= 1
			)	
		order by 2
	END
else
	BEGIN
		Select   
			MAS.ID_Status_Master, 
			MAS.Num_Proc_Master, 
			HOU.ID_Status,
			HOU.Num_Proc,
			Convert(Datetime,HOU.Dt_Emis, 103) Dt_Emis
		from vwHouse_Imp HOU With (nolock)
			join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master		
		where 
			MAS.ID_Status_Master<> HOU.ID_Status and
			HOU.Master in 
			(
				Select HOU.Master from vwHouse_Imp HOU With(nolock)  
				join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
				where 
					--MAS.ID_Status_Master<> HOU.ID_Status and 
					Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
					and MAS.ID_Status_Master <> 9 and HOU.ID_Status <> 9	
				GROUP BY 
					HOU.Master
				HAVING 
					Count(*) > 1
			)
	

	Union All   

		Select   
			MAS.ID_Status_Master, 
			MAS.Num_Proc_Master, 
			HOU.ID_Status,
			HOU.Num_Proc,
			Convert(Datetime,HOU.Dt_Emis, 103) Dt_Emis
		from vwHouse_Exp HOU With(nolock)  
			join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
		where
			MAS.ID_Status_Master<> HOU.ID_Status and
			HOU.Master in 
			(
				Select HOU.Master from vwHouse_Exp HOU With(nolock)  
				join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
				where 
					--MAS.ID_Status_Master<> HOU.ID_Status and 
					Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
					and MAS.ID_Status_Master <> 9 and HOU.ID_Status <> 9	
				GROUP BY 
					HOU.Master
				HAVING 
					Count(*) > 1
			)
			order by 2
	END*/



/*
Tests
Select   
	    MAS.ID_Status_Master, 
		MAS.Num_Proc_Master, 
		HOU.ID_Status,
		HOU.Num_Proc,
		Convert(Datetime,HOU.Dt_Emis, 103) Dt_Emis
	from vwHouse_Imp HOU With (nolock)
		join vwMaster_Imp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master		
	where  
		MAS.ID_Status_Master <> HOU.ID_Status
		and Convert(Datetime,HOU.Dt_Emis,103) > '2022-01-01'
		and (MAS.ID_Status_Master = 9 or HOU.ID_Status = 9)


Select   
	MAS.ID_Status_Master, 
	MAS.Num_Proc_Master, 
	HOU.ID_Status,
	HOU.Num_Proc,
	Convert(Datetime,HOU.Dt_Emis, 103) Dt_Emis
from vwHouse_Exp HOU With(nolock)  
	join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
where 
	MAS.ID_Status_Master <> HOU.ID_Status  
	and Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
	and (MAS.ID_Status_Master = 9 or HOU.ID_Status = 9)






	*******  referente ao status da master
use atlantis;
Select p.ID_Status,p.Num_Proc_Master, em.ID_Status, em.Num_Proc_Lea from House_Exp_Aer hea
join LLP_Master p on p.Num_Proc_Master = hea.Num_Proc_MEA
join LLP_Exp_aer em on em.Num_Proc_Lea = hea.Num_Proc_HEA
where p.ID_Status<> em.ID_Status



Select MAS.Num_Proc_Master, Count(*) 
from vwHouse_Exp HOU With(nolock)  
join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
where 
	MAS.ID_Status_Master<> HOU.ID_Status
	and Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
GROUP BY 
	MAS.Num_Proc_Master
HAVING Count(*)= 1
order by 2

Select 
	MAS.ID_Status_Master,
	MAS.Num_Proc_Master, 
	HOU.ID_Status,
	HOU.Num_Proc, Count(*) 
from vwHouse_Exp HOU With(nolock)  
join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
where 
	MAS.ID_Status_Master<> HOU.ID_Status
	and Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
GROUP BY 
	MAS.Num_Proc_Master,
	MAS.ID_Status_Master, 
	HOU.ID_Status,
	HOU.Num_Proc
HAVING Count(*)= 1
order by 2

Select MAS.Num_Proc_Master, Count(*) 
from vwHouse_Exp HOU With(nolock)  
join vwMaster_Exp_Completo MAS With(nolock) on MAS.Num_Proc_Master = HOU.Master
where 
	MAS.ID_Status_Master<> HOU.ID_Status
	and Convert(Datetime,HOU.Dt_Emis, 103) > '2022-01-01'
GROUP BY 
	MAS.Num_Proc_Master
HAVING 
	Count(*) > 1
*/
GO
