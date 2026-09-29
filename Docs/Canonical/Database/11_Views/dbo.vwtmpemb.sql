SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  VIEW vwtmpemb 

as
select month(convert(datetime,dt_par,105)) Mes,avg(par_moeda) Paridade,Nome_tp_par,cd_tp_moeda from paridade PAR
Join Tipo_Paridade TP on TP.cd_tp_par=PAR.cd_tp_par
where convert(datetime,dt_par,105)>='01-01-2007' and cd_tp_moeda in ('USD','EUR')
group by month(convert(datetime,dt_par,105)),Nome_TP_Par,cd_tp_moeda

GO
